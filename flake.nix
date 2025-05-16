{
  description = "Development flake support";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # When using flake-parts you don't really use nixpkgs in the dependencies of modules.
    # Instead everything should be resolved in the final consuming flake.
    nixpkgs.follows = "flake-parts/nixpkgs-lib";
  };

  outputs =
    inputs:
    let
      flakeModule = {
        imports = [
          inputs.devshell.flakeModule
          inputs.git-hooks.flakeModule
          inputs.treefmt.flakeModule
          ./flake-module
        ];
      };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ ];

      flake = {
        inherit flakeModule;

        templates = rec {
          default = subflake;

          subflake = {
            path = ./template/subflake;
            description = ''
              A flake using dev-flake as subflake. To be placed in a sub-folder of a project, e.g. dev.
            '';
          };

          subflake-nixpkgs = {
            path = ./template/subflake-nixpkgs;
            description = ''
              A flake using dev-flake as subflake with nixpkgs. To be placed in a sub-folder of a project, e.g. dev.
            '';
          };

          subflake-project = {
            path = ./template/subflake-project;
            description = ''
              A project using dev-flake in a subflake.
            '';
          };

          subflake-nixpkgs-project = {
            path = ./template/subflake-nixpkgs-project;
            description = ''
              A project using dev-flake in a subflake with nixpkgs, e.g. no nixpkgs/systems within the main flake.
            '';
          };

          root = {
            path = ./template/root;
            description = ''
              A flake using dev-flake.
            '';
          };

          root-project = {
            path = ./template/root-project;
            description = ''
              A project using dev-flake in root flake.
            '';
          };
        };
      };

      # Dogfood
      imports = [
        inputs.flake-parts.flakeModules.partitions
        flakeModule
      ];

      partitionedAttrs = {
        devShells = "dev";
        formatter = "dev";
        checks = "dev";
      };

      partitions.dev = {
        extraInputsFlake = ./dev;
        module.imports = [ ./dev/flake-module.nix ];
      };
    };
}
