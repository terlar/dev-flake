{
  description = "My Project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
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

      imports = [ inputs.flake-parts.flakeModules.partitions ];

      partitionedAttrs = {
        checks = "dev";
        devShells = "dev";
      };

      partitions.dev = {
        extraInputsFlake = ./dev;
        module.imports = [ ./dev/flake-module.nix ];
      };
    };
}
