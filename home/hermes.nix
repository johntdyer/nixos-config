# Hermes Agent (installed system-wide in modules/ai-tools.nix).
{
  # Points Hermes Desktop at the remote `hermes serve` backend. Overrides the
  # in-app Settings > Gateways setting for every profile. Session variables
  # load at login, so log out and back in after changing this.
  home.sessionVariables.HERMES_DESKTOP_REMOTE_URL = "https://hermes-desktop.dyer.house";
}
