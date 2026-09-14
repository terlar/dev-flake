{
  description = "Dependencies for development purposes";

  inputs = {
    dev-flake.url = "github:terlar/dev-flake";
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
  };

  outputs = _: { };
}
