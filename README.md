# nixos-config

Flake-based NixOS config for the laptop (hostname `nixos`). Lives in `~/nixos-config` as a git repo. No home-manager: per-user settings are done with NixOS options.

## Layout
- `flake.nix`: inputs (nixpkgs 26.05, nixpkgs-unstable, hermes-agent, claude-desktop) and the `nixos` system
- `hosts/laptop/`: hostname, `stateVersion`, the imports list, and the generated hardware config
- `modules/core.nix`: nix settings, gc, boot loader, networking, locale, base CLI tools, nh
- `modules/laptop.nix`: fingerprint, power, firmware updates, bluetooth, lid, zram
- `modules/desktop.nix`: keyboard, PipeWire, printing, Firefox, fonts
- `modules/gnome.nix`: GNOME, Files, Dash to Dock, Ulauncher, dconf defaults
- `modules/users.nix`: the `jdyer` account
- `modules/1password.nix`: 1Password app, CLI, browser integration, SSH agent
- `modules/git.nix`: git config and SSH commit signing via 1Password
- `modules/shell.nix`: zsh, oh-my-zsh, aliases, direnv
- `modules/apps.nix`: desktop apps
- `modules/tailscale.nix`: Tailscale VPN and MagicDNS
- `modules/ai-tools.nix`: Claude Desktop, Claude Code, Hermes Agent

## Daily commands
| Task | Command |
|---|---|
| Apply changes | `rebuild` |
| Try without making it the boot default | `rebuild-test` |
| Update all inputs and rebuild | `update`, then commit `flake.lock` |
| Update one input | `nix flake update <input>`, then `rebuild` |
| Roll back | `rollback` (`nh os rollback`), or pick an older generation at boot |
| List generations | `generations` (`nh os info`) |
| Clean old generations | `nh clean all --keep 5` |
| Search packages | `nix search nixpkgs <name>` |
| Format all files | `nix fmt` |

Never run plain `sudo nixos-rebuild switch --flake .`: it leaves root-owned files in the repo. If you need nixos-rebuild, use `nixos-rebuild switch --flake . --sudo`.

## Rules of thumb
- `git add` new files before rebuilding. Flakes only see files git knows about.
- Commit `flake.lock`. It pins exact versions so rebuilds are reproducible.
- Never change `system.stateVersion` after install.
- New concern = new module file in `modules/`, then add it to `imports` in `hosts/laptop/default.nix`.
- After changing the shell, session variables, GNOME extensions or dconf defaults, log out and back in.
