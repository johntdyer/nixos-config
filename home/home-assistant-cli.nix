# Home Assistant CLI (hass-cli), with its token read from 1Password.
{ pkgs, ... }:
{
  home.packages = [ pkgs.home-assistant-cli ];

  # hass-cli reads HASS_SERVER and HASS_TOKEN from the environment. Both live
  # in ~/.config/hass-cli/env (not in this public repo). HASS_TOKEN there is an
  # op:// reference, so `op run` fetches it from 1Password for each command
  # and the token never sits in a shell variable or file. --no-masking lets
  # hass-cli write straight to the terminal (no "broken pipe" errors from
  # `op run` when piping to head); hass-cli never prints the token anyway.
  programs.zsh.shellAliases.hass-cli = "op run --no-masking --env-file=$HOME/.config/hass-cli/env -- hass-cli";
}
