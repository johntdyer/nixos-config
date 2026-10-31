# AI tools: Claude Desktop, Claude Code, Hermes Agent.
{ pkgs, pkgs-unstable, inputs, ... }:
{
  # Claude Desktop runs local file work in a QEMU/KVM VM.
  users.users.jdyer.extraGroups = [ "kvm" ];
  boot.kernelModules = [ "vhost_vsock" ];

  programs.claude-desktop.enable = true;

  environment.systemPackages = [
    # From unstable, since Claude Code updates often.
    pkgs-unstable.claude-code

    # Nous Research Hermes Agent, straight from its own flake.
    inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
