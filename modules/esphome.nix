# ESPHome and serial tools: build/flash ESP32/ESP8266 firmware for Home
# Assistant, and talk to boards over USB serial.
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    esphome
    cutecom # Qt serial terminal: pick port + baud, send/receive, hex view
    gtkterm # GTK serial terminal, simpler; fits GNOME
  ];

  # Serial access to boards plugged in over USB (/dev/ttyUSB*, /dev/ttyACM*),
  # so `esphome run`, CuteCom and GTKTerm work without sudo. Wireless (OTA)
  # updates don't need this.
  users.users.jdyer.extraGroups = [ "dialout" ];
}
