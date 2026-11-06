# Hermes Agent (installed system-wide in modules/ai-tools.nix).
{ config, ... }:
{
  # Points Hermes Desktop at the remote `hermes serve` backend. Overrides the
  # in-app Settings > Gateways setting for every profile. Both variables are
  # required. Session variables load at login, so log out and back in after
  # changing this.
  home.sessionVariables = {
    HERMES_DESKTOP_REMOTE_URL = "https://hermes-desktop.dyer.house";
    # Token lives outside the repo and the Nix store (~/.config/hermes/remote-token,
    # mode 600); read at login.
    HERMES_DESKTOP_REMOTE_TOKEN = "$(cat ${config.home.homeDirectory}/.config/hermes/remote-token 2>/dev/null)";
  };
}
