# nixos-config

Flake-based NixOS config for the laptop. Lives in `~/nixos-config` as a git repo.

## Layout
- `flake.nix`: inputs (nixpkgs versions) and the `nixos` system (matches the hostname)
- `hosts/laptop/`: machine-specific settings and hardware config
- `modules/`: reusable pieces (core, laptop, desktop, users)

## Daily commands
| Task | Command |
|---|---|
| Apply changes | `nh os switch` (or `sudo nixos-rebuild switch --flake .`) |
| Try without making it the boot default | `nh os test` |
| Update all inputs | `nix flake update` then `nh os switch` |
| See what changed | `nh os switch` shows a package diff automatically |
| Roll back | `sudo nixos-rebuild switch --rollback`, or pick an older generation at boot |
| Clean old generations | `nh clean all --keep 5` |
| Search packages | `nix search nixpkgs <name>` |
| Format all files | `nix fmt` |

## Rules of thumb
- Commit before every rebuild. Flakes only see files git knows about (`git add` new files).
- Commit `flake.lock`. It pins exact versions so rebuilds are reproducible.
- Never change `system.stateVersion` after install.
- New concern = new module file in `modules/`, then add it to `imports`.
