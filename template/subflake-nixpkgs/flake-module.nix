{ inputs, ... }:

{
  imports = [ inputs.dev-flake.flakeModule ];

  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-darwin"
    "x86_64-linux"
  ];

  dev.name = "my-project";

  perSystem = {
    treefmt.programs = {
      yamlfmt.enable = true;
    };

    pre-commit.settings.hooks = {
      conform.enable = true;
    };
  };
}
