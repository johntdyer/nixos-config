# SSH client defaults for every host. Personal hosts go in ~/.ssh/config, not in this repo.
_: {
  # Merges with the IdentityAgent block in 1password.nix.
  programs.ssh.extraConfig = ''
    Host *
      # Keep idle sessions alive through NAT and Wi-Fi drops.
      ServerAliveInterval 60
      ServerAliveCountMax 3
      # Reuse one connection per host: faster repeat ssh, git and scp.
      ControlMaster auto
      ControlPath ~/.ssh/cm-%C
      ControlPersist 10m
  '';
}
