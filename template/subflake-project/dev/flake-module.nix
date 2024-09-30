{ inputs, ... }:

{
  imports = [ inputs.dev-flake.flakeModule ];

  dev.name = "my-project";

  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        programs.nixfmt = {
          enable = true;
          package = pkgs.nixfmt-rfc-style;
        };
      };
    };
}
