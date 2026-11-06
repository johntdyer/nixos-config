# Infrastructure CLIs: Terraform, OpenTofu and sops.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Unfree (BSL license): needs allowUnfree, set in modules/core.nix and
    # shared here through home-manager.useGlobalPkgs.
    terraform
    opentofu # `tofu`
    sops
  ];
}
