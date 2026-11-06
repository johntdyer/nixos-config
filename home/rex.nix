# Rex (superlogical.com/rex): rex CLI, xterm-rex terminfo, SSH fallback, local personal server, and ~/.config/rex/init.lua with remote hosts from an untracked hosts.lua.
{ config, inputs, ... }:
{
  imports = [ inputs.rex.homeManagerModules.default ];

  # Installs rex, the xterm-rex terminfo entry, and an SSH fallback to
  # xterm-256color for hosts without it (needs programs.ssh.enable, set in
  # home/ssh.nix).
  programs.rex.enable = true;

  # Personal server as a systemd user service (`rex`), started at login and
  # stopped at logout (`loginctl enable-linger jdyer` keeps it running).
  # Local only: listens on /run/user/1000/rex/server.sock, nothing on the
  # network. Needed by Rex Linux (home/rex-linux.nix), which never starts a
  # server itself.
  services.rex.enable = true;

  # Read-only link into the store: change it here, not in place.
  # Remote hosts are personal, so they live in ~/.config/rex/hosts.lua (not in
  # this repo), one `rex.host{ label = "...", endpoint = "https://..." }` per
  # host. Tries require first, then a direct dofile; a missing or broken
  # hosts.lua is skipped, so check with `rex hosts list`.
  xdg.configFile."rex/init.lua" = {
    text = ''
      -- Managed by home-manager (nixos-config/home/rex.nix). Do not edit.
      -- Remote hosts: ~/.config/rex/hosts.lua (local, untracked).
      local ok = pcall(require, "hosts")
      if not ok and dofile and os and os.getenv then
        local base = os.getenv("XDG_CONFIG_HOME")
          or ((os.getenv("HOME") or "") .. "/.config")
        pcall(dofile, base .. "/rex/hosts.lua")
      end
    '';
    # Rex doesn't watch the file; reload the local server if one is running.
    onChange = ''
      rex=${config.home.profileDirectory}/bin/rex
      if [ -x "$rex" ]; then "$rex" config reload >/dev/null 2>&1 || true; fi
    '';
  };
}
