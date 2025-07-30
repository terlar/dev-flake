{ inputs, ... }:

{
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
}
