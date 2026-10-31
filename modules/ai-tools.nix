# AI coding tools.
{ pkgs, pkgs-unstable, inputs, ... }:
{

  programs.claude-desktop.enable = true; 
  environment.systemPackages = [
    # From unstable, since Claude Code updates often.
    pkgs-unstable.claude-code

    # Nous Research Hermes Agent, straight from its own flake.
    inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
