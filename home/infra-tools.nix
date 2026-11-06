# Infrastructure CLIs: Terraform, OpenTofu, sops and the Google Cloud CLI.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Unfree (BSL license): needs allowUnfree, set in modules/core.nix and
    # shared here through home-manager.useGlobalPkgs.
    terraform
    opentofu # `tofu`
    sops

    # gcloud, gsutil, bq. Components are added here, not with
    # `gcloud components install` (the store is read-only). gke-gcloud-auth-plugin
    # is what kubectl needs for GKE clusters.
    (google-cloud-sdk.withExtraComponents (
      with google-cloud-sdk.components;
      [
        gke-gcloud-auth-plugin
      ]
    ))
  ];
}
