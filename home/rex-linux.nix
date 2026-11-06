# Rex Linux (github:shuv1337/rex-rune): unofficial native GUI client for Rex servers. Temporary until Superlogical ships a Linux client.
#
# Not from Superlogical: early-stage code from one developer. The flake input
# (rex-rune in flake.nix) is pinned to a commit, so it only changes when the
# rev is bumped by hand.
#
# Build: nothing is cached. The first rebuild compiles Rust, Zig and Ghostty's
# VT library locally and runs upstream's tests, so it is slow. The input has
# no nixpkgs follows on purpose (upstream needs its own newer Rust and Zig
# 0.17), which adds a third nixpkgs copy to flake.lock.
#
# Installs: rex-linux, its desktop entry and icons, plus the rex-probe and
# rex-workspace-probe diagnostics. Never run the probes against real servers:
# they create and remove sessions.
#
# Hosts: saved by the app in ~/.config/rex-linux/workspace.json (Settings >
# Remote Hosts), separate from ~/.config/rex/hosts.lua. Use the same
# https://<host>.<tailnet>.ts.net addresses.
#
# Try without rebuilding:
#   nix run github:shuv1337/rex-rune/d0547f7 -- --endpoint https://<host>.<tailnet>.ts.net
#
# Remove: delete this file and the rex-rune input in flake.nix, then rebuild.
{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.rex-rune.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
