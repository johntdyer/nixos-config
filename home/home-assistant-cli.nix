# Home Assistant CLI (hass-cli), with its token read from 1Password.
{ lib, pkgs, ... }:
let
  # hass-cli reads HASS_SERVER and HASS_TOKEN from the environment. Both live
  # in ~/.config/hass-cli/env (not in this public repo). HASS_TOKEN there is an
  # op:// reference, so `op run` fetches it from 1Password on each run and the
  # token never sits in a shell variable or file. --no-masking lets hass-cli
  # write straight to the terminal (no "broken pipe" from `op run` when piping
  # to head); hass-cli never prints the token anyway.
  #
  # A wrapper on PATH, not an alias or shell function: tab completion runs
  # `hass-cli` from PATH to look up entity IDs, so it needs the env too
  # (without it, hass-cli scans the LAN with "Trying to locate Home
  # Assistant..."). The package's zsh completions (share/zsh) are kept, and
  # HM's zsh already has them on fpath, so no eval line in ~/.zshrc.
  #
  # Patch: hass-cli 1.0.0 (and upstream master) returns (value, help) tuples
  # from its completion functions, but click 8 expects CompletionItem objects,
  # so Tab on entity IDs fails with "'tuple' object has no attribute 'help'".
  # This wraps each completer so its results are still (value, help) tuples
  # (upstream's tests call dict() on them) but also carry the .type, .value
  # and .help attributes click reads. Drop it once upstream fixes
  # homeassistant_cli/autocompletion.py.
  hass-cli-patched = pkgs.home-assistant-cli.overridePythonAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      cat >> homeassistant_cli/autocompletion.py <<'EOF'


      class _CompletionItem(tuple):
          type = "plain"
          value = property(lambda self: self[0])
          help = property(lambda self: self[1] or None)


      def _as_items(func):
          def wrapper(ctx, param, incomplete):
              return [_CompletionItem(item) for item in func(ctx, param, incomplete)]

          return wrapper


      services = _as_items(services)
      entities = _as_items(entities)
      events = _as_items(events)
      table_formats = _as_items(table_formats)
      api_methods = _as_items(api_methods)
      wsapi_methods = _as_items(wsapi_methods)
      areas = _as_items(areas)
      EOF
    '';
  });

  hass-cli = pkgs.symlinkJoin {
    name = "hass-cli-1password";
    paths = [ hass-cli-patched ];
    postBuild = ''
      rm $out/bin/hass-cli
      cat > $out/bin/hass-cli <<EOF
      #!${pkgs.runtimeShell}
      exec op run --no-masking --env-file="\$HOME/.config/hass-cli/env" -- ${lib.getExe hass-cli-patched} "\$@"
      EOF
      chmod +x $out/bin/hass-cli
    '';
  };
in
{
  home.packages = [ hass-cli ];
}
