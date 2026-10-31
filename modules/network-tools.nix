# Network troubleshooting tools: DNS, whois, mosh, Wireshark/tshark.
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    dnsutils # dig, nslookup, nsupdate
    whois
    mosh # client only; to accept mosh connections to this laptop, use programs.mosh.enable instead
  ];

  # Wireshark GUI + tshark CLI (the full package includes both).
  # Creates a `wireshark` group whose members can capture without sudo
  # (through a setcap dumpcap wrapper).
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  users.users.jdyer.extraGroups = [ "wireshark" ];
}
