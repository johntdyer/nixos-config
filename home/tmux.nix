# tmux: ported from the Mac config. Ctrl+Space prefix, Catppuccin, resurrect/continuum, SSH-aware splits.
{ lib, pkgs, ... }:
let
  # Prints the ssh command running in a pane (if any), so splits and new
  # windows reconnect to the same host. With ControlMaster (home/ssh.nix) the
  # new connection is instant.
  sshSplit = pkgs.writeShellApplication {
    name = "tmux-ssh-split";
    runtimeInputs = [ pkgs.procps ];
    text = ''
      pane_pid="$1"
      for pid in $(pgrep -P "$pane_pid" || true); do
        if [ "$(ps -o comm= -p "$pid")" = "ssh" ]; then
          ps -o args= -p "$pid"
          exit 0
        fi
      done
    '';
  };
  split = lib.getExe sshSplit;
in
{
  # home-manager writes ~/.config/tmux/tmux.conf in this order: the options
  # below, then each plugin (its extraConfig, then the plugin itself), then
  # extraConfig. Plugin options go in that plugin's extraConfig so they are
  # set before it loads.
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    historyLimit = 50000;
    baseIndex = 1; # windows and panes
    escapeTime = 0;
    clock24 = true;
    mouse = true;
    focusEvents = true;
    prefix = "C-Space";
    keyMode = "vi";
    # prefix + h/j/k/l to switch panes, prefix + H/J/K/L to resize by 5.
    customPaneNavigationAndResize = true;

    # Nix installs these; no TPM. resurrect and continuum are loaded at the
    # end of extraConfig instead, because continuum must load after
    # status-right is set or auto-save silently stops.
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g status-position top
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_window_text " #W"
          set -g @catppuccin_window_default_text " #W"
          set -g @catppuccin_window_current_text " #W"
          set -g @catppuccin_status_left_separator ""
          set -g @catppuccin_date_time_text " %H:%M"
        '';
      }
      yank
      vim-tmux-navigator # Ctrl+h/j/k/l across tmux panes and nvim splits
      {
        plugin = fingers;
        extraConfig = "set -g @fingers-key T";
      }
      extrakto
      tmux-fzf
    ];

    extraConfig = ''
      # --- General ---
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -as terminal-features ",xterm-ghostty:RGB"
      set -g renumber-windows on
      set -g set-clipboard on
      # keyMode = "vi" also sets vi keys in the command prompt; keep emacs there like on the Mac.
      set -g status-keys emacs

      # --- Window naming ---
      # Let tmux name windows after the foreground process (k9s, nvim, ssh),
      # or the directory name when it's just zsh.
      set -g allow-rename off
      setw -g automatic-rename on
      setw -g automatic-rename-format '#{?#{==:#{pane_current_command},zsh},#{b:pane_current_path},#{pane_current_command}}'

      # --- Status bar (needs Catppuccin loaded) ---
      set -g status-left ""
      set -g status-right-length 100
      set -g status-right "#{E:@catppuccin_status_directory}#{E:@catppuccin_status_date_time}"

      # --- Splits and new windows (reconnect if the pane is in SSH) ---
      bind \\ run-shell 'ssh_cmd=$(${split} #{pane_pid}); \
        if [ -n "$ssh_cmd" ]; then \
          tmux split-window -h -c "#{pane_current_path}" "$ssh_cmd"; \
        else \
          tmux split-window -h -c "#{pane_current_path}"; \
        fi'
      bind - run-shell 'ssh_cmd=$(${split} #{pane_pid}); \
        if [ -n "$ssh_cmd" ]; then \
          tmux split-window -v -c "#{pane_current_path}" "$ssh_cmd"; \
        else \
          tmux split-window -v -c "#{pane_current_path}"; \
        fi'
      unbind '"'
      unbind %
      bind c run-shell 'ssh_cmd=$(${split} #{pane_pid}); \
        if [ -n "$ssh_cmd" ]; then \
          tmux new-window "$ssh_cmd"; \
        else \
          tmux new-window -c "#{pane_current_path}"; \
        fi'

      # --- Copy mode (vi), Wayland clipboard instead of pbcopy ---
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel "wl-copy"
      bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "wl-copy"

      # --- Reload ---
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded"

      # --- Session save/restore: keep last ---
      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-processes 'ssh k9s lazygit htop btop'
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '15'
      run-shell ${pkgs.tmuxPlugins.resurrect.rtp}
      run-shell ${pkgs.tmuxPlugins.continuum.rtp}
    '';
  };
}
