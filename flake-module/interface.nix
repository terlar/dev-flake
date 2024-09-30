{
  self,
  flake-parts-lib,
  lib,
  ...
}:

let
  inherit (flake-parts-lib) mkPerSystemOption;
  inherit (lib) types;
in
{
  options = {
    dev = {
      name = lib.mkOption {
        type = types.str;
        description = "The name of the project.";
        default = "project";
        example = "my-project";
      };

      rootSrc = lib.mkOption {
        type = types.path;
        description = "The root source of the project.";
        default = self.outPath;
      };
    };

    perSystem = mkPerSystemOption {
      options.dev = {
        devshell = {
          enable = lib.mkOption {
            type = types.bool;
            description = "Whether to enable devshell integration.";
            default = true;
            example = false;
          };

          addCommands = lib.mkOption {
            type = types.bool;
            description = "Whether to add commands.";
            default = true;
            example = false;
          };

          addReadmeCommand = lib.mkOption {
            type = types.bool;
            description = "Whether to add readme command.";
            default = true;
            example = false;
          };
        };

        pre-commit.enable = lib.mkOption {
          type = types.bool;
          description = "Whether to enable pre-commit integration.";
          default = true;
          example = false;
        };

        treefmt.enable = lib.mkOption {
          type = types.bool;
          description = "Whether to enable treefmt integration.";
          default = true;
          example = false;
        };
      };
    };
  };
}
