{
  description = "My Project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    dev-flake = {
      url = "github:terlar/dev-flake";
      inputs.flake-parts.follows = "flake-parts";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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

      perSystem =
        { config, ... }:
        {
          formatter = config.treefmt.programs.nixfmt.package;
        };
    };
}
