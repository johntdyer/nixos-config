# ESPHome CLI for building and flashing ESP32/ESP8266 firmware for Home Assistant.
{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.esphome ];

  # Serial access to boards plugged in over USB (/dev/ttyUSB*, /dev/ttyACM*),
  # so `esphome run` can flash without sudo. Wireless (OTA) updates don't need this.
  users.users.jdyer.extraGroups = [ "dialout" ];
}
