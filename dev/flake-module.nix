{
  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-darwin"
    "x86_64-linux"
  ];

  dev.name = "dev-flake";

  perSystem = {
    treefmt.programs = {
      mdsh.enable = true;
    };

    pre-commit.settings.hooks = {
      conform.enable = true;
    };
  };
}
