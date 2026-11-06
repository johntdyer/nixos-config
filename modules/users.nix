# Your user account and its packages. Dotfiles are in home/ (home-manager).
{ pkgs, pkgs-unstable, ... }:
{
  users.users.jdyer = {
    isNormalUser = true;
    description = "John Dyer";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
    ];
    shell = pkgs.zsh;
    packages = [
      # From unstable for now: vscode 1.144.0 on nixos-26.05 fails in
      # patchPhase ("cannot remove .../@vscode/ripgrep/bin/rg"; upstream moved
      # ripgrep). Unstable's generic.nix has the fix. Switch back to
      # pkgs.vscode once 26.05 gets the backport (2026-11-06).
      pkgs-unstable.vscode
    ];
  };
}
