# gmailctl: Gmail filters and labels as code (shell completions included).
{ pkgs, ... }:
{
  # Config and OAuth files stay in ~/.gmailctl, not in this public repo:
  # config.jsonnet lists personal addresses, credentials.json and token.json
  # are secrets.
  home.packages = [ pkgs.gmailctl ];
}
