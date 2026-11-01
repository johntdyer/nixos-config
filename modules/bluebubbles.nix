# BlueBubbles client: iMessage via the BlueBubbles server on the Mac mini (LAN only, no Private API)
{ pkgs-unstable, ... }:
{
  environment.systemPackages = [ pkgs-unstable.bluebubbles ];
}
