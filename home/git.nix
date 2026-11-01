# Git, with commits and tags signed by your 1Password SSH key.
{
  config,
  lib,
  osConfig,
  ...
}:
let
  signingKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDeB4ULoMnluLjvEigOcKDW74WO6nDy2iop8zKgaqhuj2wm6YzO2lhLmKvhSdIi3ulqAu2Qbxhyn+jwTWH+EcDO5VrwwFHP9Tf2ptKAkH2lduJT9WvXTJzrNuqyTpdXIAoWm8WWVkiRy7Z1qeRqfjTqiLLMyatvvzM2BCLlFp6i34LEODvgh9QAyo1noziViy0RLlwxxaTNis+hAENJLAIneFY/fmlgcVcwRwStvWcdnAyd6H9A66WX4g+YN8XMQMQlp/LpQiC94N6D1Lwd1yTD2+4VpVEcFvA/IH+NEUkXvt8/L5xjme4HVLRMNIO+6Yvvf/JMZ0az0EC6JqYWKPHoQ7KSYJdSBoTUYXGkAyyrTWm5X5Rb7vNJC0VNZHZF/CZSpnM1Zx1Unqq2wngZ3xQazpK3dP9ryEeYEghhafM/9D0Drm1qPfahFXa6qFqoU+vK45q3bLDt5tf4fyhS5WWbRfnyjcxm93pdZmbIW1V7Qo3NOExI7FWBlaCwcxWZ3aDiRqDLUB6GB3GTYLWnPWIJCRevjVyWIGQrdgRdA8jRBMYTymNabGyu5LzRO28W60aEZ4f/fqU8w5EC12Mro3nP4Gv9m2u0BnbuX5kMQUGP/w7eojVB/dk3ehYsR5q0ZP91FNdsCnGYnBAh30+K6tx419FDMKocfyAnKr5NK+qpRQ==";
  email = "johntdyer@gmail.com";
in
{
  programs.git = {
    enable = true;
    signing = {
      key = signingKey;
      format = "ssh";
      signByDefault = true; # commit.gpgsign and tag.gpgsign
      # 1Password's signer, from the app installed in modules/1password.nix.
      signer = lib.getExe' osConfig.programs._1password-gui.package "op-ssh-sign";
    };
    settings = {
      user = {
        name = "John Dyer";
        inherit email;
      };
      init.defaultBranch = "main";
      gpg.ssh.allowedSignersFile = "${config.xdg.configHome}/git/allowed_signers";
    };
  };

  # Lets `git log --show-signature` verify your own signatures locally.
  xdg.configFile."git/allowed_signers".text = ''
    ${email} ${signingKey}
  '';
}
