# Tailscale VPN + Trayscale GUI. First time: `sudo tailscale up`, then log in from the link.
{ pkgs, ... }:
{
  services.tailscale = {
    enable = true;
    # Lets this laptop use exit nodes and subnet routes from other machines.
    useRoutingFeatures = "client";
    # Opens Tailscale's UDP port so it can make direct peer connections
    # instead of falling back to slower relays.
    openFirewall = true;
    # Applied with `tailscale set` on every boot:
    # --accept-routes: use subnet routes other machines advertise (off by default on Linux).
    # --operator: lets jdyer (and Trayscale) control Tailscale without sudo.
    extraSetFlags = [
      "--accept-routes"
      "--operator=jdyer"
    ];
  };

  # GNOME-style GUI: connect/disconnect, pick an exit node, see peers.
  environment.systemPackages = [ pkgs.trayscale ];

  # MagicDNS (reaching machines by name) works cleanly through
  # systemd-resolved; without it, Tailscale and NetworkManager fight over
  # /etc/resolv.conf.
  services.resolved.enable = true;

  # tailscale0 is NOT a trusted firewall interface, so other tailnet devices
  # can't reach services on this laptop unless you open them on purpose.
}
