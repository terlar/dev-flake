{
  description = "Dependencies for development purposes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    dev-flake = {
      url = "github:terlar/dev-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = _: { };
}
