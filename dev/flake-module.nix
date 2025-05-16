{
  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-darwin"
    "x86_64-linux"
  ];

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

      pre-commit.settings.hooks = {
        conform.enable = true;
      };
    };
}
