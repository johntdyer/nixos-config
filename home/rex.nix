# Rex (superlogical.com/rex): rex CLI, xterm-rex terminfo, SSH fallback, and a personal Rex server as a systemd user service.
{ inputs, ... }:
{
  imports = [ inputs.rex.homeManagerModules.default ];

  # Installs rex, the xterm-rex terminfo entry, and an SSH fallback to
  # xterm-256color for hosts without it (needs programs.ssh.enable, set in
  # home/ssh.nix).
  programs.rex.enable = true;

  # Personal server for jdyer (systemd user service `rex`). Stops at logout
  # unless `loginctl enable-linger jdyer` is run once. The shared/login
  # servers need root and would go in a NixOS module instead.
  services.rex.enable = true;
}
