# 1Password CLI (`op`) and desktop app.
{ ... }:
{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Lets these users unlock 1Password with system auth (polkit),
    # and enables CLI integration with the desktop app.
    polkitPolicyOwners = [ "jdyer" ];
  };
}
