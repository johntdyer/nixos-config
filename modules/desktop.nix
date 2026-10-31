# Desktop basics shared by any desktop environment.
# The GNOME settings themselves live in gnome.nix.
{ pkgs, ... }:
{
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Audio via PipeWire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;

  programs.firefox.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];
}
