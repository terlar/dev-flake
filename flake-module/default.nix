{ config, lib, ... }:

let
  cfg = config.dev;
in
{
  imports = [ ./interface.nix ];

  config.perSystem =
    { config, pkgs, ... }:
    lib.mkMerge [
      (lib.mkIf cfg.devshell.enable {
        devshells.default = {
          inherit (cfg) name;

          commands = lib.optional cfg.devshell.addReadmeCommand {
            help = "prints the readme";
            name = "readme";
            command = ''
              export PRJ_ROOT=''${PRJ_ROOT:-$(git rev-parse --show-toplevel)}
              export README="$PRJ_ROOT/README.md"

              if [[ -f "$README" ]]; then
                ${pkgs.glow}/bin/glow "$README"
              elif [[ -f "$PRJ_ROOT/README.org" ]]; then
                nix --experimental-features 'nix-command flakes' run nixpkgs#pandoc -- -f org -t markdown -o - "$PRJ_ROOT/README.org" \
                  | ${pkgs.glow}/bin/glow
              else
                >&2 echo "error: no README.md file inside $PRJ_ROOT"
              fi
            '';
          };
        };
      })

      (lib.mkIf cfg.treefmt.enable {
        treefmt = {
          flakeCheck = lib.mkDefault (!cfg.pre-commit.enable);
          flakeFormatter = lib.mkDefault false;
          projectRootFile = lib.mkDefault "flake.nix";
        };

        pre-commit.settings.hooks.treefmt.enable = cfg.treefmt.enable;

        devshells = lib.mkIf cfg.devshell.enable {
          default.commands = lib.optional cfg.devshell.addCommands {
            package = config.treefmt.build.wrapper;
          };
        };
      })

      (lib.mkIf cfg.pre-commit.enable {
        pre-commit = {
          check.enable = lib.mkDefault true;
          settings.rootSrc = lib.mkForce cfg.rootSrc;
          settings.hooks = {
            deadnix.enable = lib.mkDefault true;
            statix.enable = lib.mkDefault true;
          };
        };

        devshells = lib.mkIf cfg.devshell.enable {
          default = {
            devshell.startup.pre-commit-install.text = config.pre-commit.installationScript;
            commands = lib.optional cfg.devshell.addCommands { inherit (config.pre-commit.settings) package; };
          };
        };
      })
    ];
}
