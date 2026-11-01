# Your user account and its packages. Dotfiles are in home/ (home-manager).
{ pkgs, ... }:
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
    packages = with pkgs; [
      vscode
      # Pull a single newer package from unstable like this:
      # pkgs-unstable.some-package
    ];
  };
}
