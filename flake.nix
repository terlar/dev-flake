{
  description = "Development flake support";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    call-flake.url = "github:divnix/call-flake";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} rec {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      # Dogfooding
      imports = [flake.flakeModule];

      flake = {
        templates = {
          default = {
            path = ./template/default;
            description = ''
              A flake using dev-flake. To be placed in a sub-folder of a project, e.g. dev.
            '';
          };

          project = {
            path = ./template/project;
            description = ''
              A project using dev-flake.
            '';
          };
        };

        flakeModule = let
          importApply = modulePath: staticArgs:
            inputs.nixpkgs.lib.setDefaultModuleLocation modulePath (import modulePath staticArgs);
        in {
          imports = [
            inputs.devshell.flakeModule
            inputs.pre-commit-hooks.flakeModule
            inputs.treefmt.flakeModule
            (importApply ./flake-module {inherit (inputs) call-flake;})
          ];
        };
      };

      dev = {
        name = "dev-flake";
        rootSrc = ./.;
      };

      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;
        treefmt.programs.alejandra.enable = true;
      };
    };
}
