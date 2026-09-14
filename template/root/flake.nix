{
  description = "My Project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    dev-flake = {
      url = "github:terlar/dev-flake";
      inputs.flake-parts.follows = "flake-parts";
    };
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      imports = [ inputs.dev-flake.flakeModule ];

      dev.name = "my-project";

      perSystem = {
        treefmt.programs = {
          yamlfmt.enable = true;
        };

        pre-commit.settings.hooks = {
          conform.enable = true;
        };
      };
    };
}
