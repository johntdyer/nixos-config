# SSH client defaults for every host. Personal hosts go in ~/.ssh/config.local
# (not in this repo); the 1Password agent is set system-wide in modules/1password.nix.
_: {
  programs.ssh = {
    enable = true;
    # Don't add home-manager's legacy defaults; only what's below.
    enableDefaultConfig = false;
    # Included at the top, so a host's own settings there win over "*" below.
    # A missing file is ignored.
    includes = [ "~/.ssh/config.local" ];
    settings."*" = {
      # Keep idle sessions alive through NAT and Wi-Fi drops.
      ServerAliveInterval = 60;
      ServerAliveCountMax = 3;
      # Reuse one connection per host: faster repeat ssh, git and scp.
      ControlMaster = "auto";
      ControlPath = "~/.ssh/cm-%C";
      ControlPersist = "10m";
    };
  };
}
