{
  description = "Development flake support";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
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

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } rec {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      # Dogfooding
      imports = [ flake.flakeModule ];

      flake = {
        templates = rec {
          default = subflake;

          subflake = {
            path = ./template/subflake;
            description = ''
              A flake using dev-flake as subflake. To be placed in a sub-folder of a project, e.g. dev.
            '';
          };

          subflake-project = {
            path = ./template/subflake-project;
            description = ''
              A project using dev-flake in a subflake.
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

        flakeModule =
          let
            importApply =
              modulePath: staticArgs:
              inputs.nixpkgs.lib.setDefaultModuleLocation modulePath (import modulePath staticArgs);
          in
          {
            imports = [
              inputs.devshell.flakeModule
              inputs.git-hooks.flakeModule
              inputs.treefmt.flakeModule
              (importApply ./flake-module { inherit (inputs) call-flake; })
            ];
          };
      };

      dev.name = "dev-flake";

      perSystem =
        { config, pkgs, ... }:
        {
          formatter = config.treefmt.programs.nixfmt.package;
          treefmt.programs = {
            nixfmt = {
              enable = true;
              package = pkgs.nixfmt-rfc-style;
            };
            mdsh.enable = true;
          };
        };
    };
}
