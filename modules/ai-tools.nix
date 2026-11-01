# AI tools: Claude Desktop, Claude Code, Hermes Agent (CLI + Desktop).
{
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:
{
  # Claude Desktop runs local file work in a QEMU/KVM VM.
  users.users.jdyer.extraGroups = [ "kvm" ];
  boot.kernelModules = [ "vhost_vsock" ];

  programs.claude-desktop.enable = true;

  environment.systemPackages = [
    # From unstable, since Claude Code updates often.
    pkgs-unstable.claude-code

    # Nous Research Hermes Agent, straight from its own flake.
    # It builds against our nixpkgs-unstable (see the hermes-agent input in
    # flake.nix for why, and how to undo it if a build breaks).
    inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default
    # Hermes Desktop (Electron app with a launcher entry). Connects to a
    # remote `hermes serve` backend: Settings > Gateways > Remote gateway.
    inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.desktop
  ];

  # Optional: pin the remote backend instead of setting it in the app. This
  # overrides the in-app setting for every profile, and the repo is public,
  # so a tailnet hostname is better than an IP here.
  # environment.sessionVariables.HERMES_DESKTOP_REMOTE_URL = "http://<host>:9119";
}
