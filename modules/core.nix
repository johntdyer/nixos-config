# Base system settings shared by any machine.
{ pkgs, ... }:
{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "@wheel" ];
    # You rebuild before committing, so the "Git tree is dirty" warning is noise.
    warn-dirty = false;
  };

  # Weekly cleanup of old generations so /nix doesn't fill the disk.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Deduplicate the store on a schedule instead of during every build
  # (auto-optimise-store slows each rebuild).
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  # Skip building the offline NixOS manual on every rebuild (it re-renders
  # docs for every option). Use search.nixos.org instead. Man pages stay.
  documentation.nixos.enable = false;

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;  # boot menu entries kept
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
    htop
    ripgrep
    fd
    jq
    nvd                 # package diff between generations
    nix-output-monitor  # prettier build output (`nom`)
  ];

  # `nh os switch` = rebuild with a diff; `nh clean all` = tidy old generations.
  programs.nh = {
    enable = true;
    flake = "/home/jdyer/nixos-config";
  };
}
