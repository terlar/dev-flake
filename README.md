# dev-flake

Nix flake to support the pattern of using a separate development sub-flake. dev-flake can also be used within the root flake. The integration is done via [flake-parts](https://flake.parts).

## Features

Features are enabled by default in order to get "the best experience out of the box", however it is possible to opt-out from the default configuration and/or add additional configuration. See available configuration options in the [flake module interface](flake-module/interface.nix) and the corresponding documentation for each dependency flake module.

Dependency flake modules:

- [devshell](https://flake.parts/options/devshell.html)
- [git-hooks-nix](https://flake.parts/options/git-hooks-nix.html)
- [treefmt-nix](https://flake.parts/options/treefmt-nix.html)

### Default devShell

The default devShell is provided via [devshell](https://flake.parts/options/devshell.html).

- Installs [pre-commit](https://pre-commit.com) hooks.
- Menu with available commands.
- Named shell prompt
- Can be used together with [direnv](https://direnv.net) for seamless shell integration.
  - See the example [subflake-project template](template/subflake-project).

### treefmt

[treefmt](https://numtide.github.io/treefmt) is a nice abstraction on top of formatters to format the whole project.

To configure more formatters, see the [treefmt-nix documentation](https://flake.parts/options/treefmt-nix.html).

### pre-commit hooks

[pre-commit](https://pre-commit.com) is a framework to configure and run git hooks before commit. Usually formatting and linting.

- Configures flake check to run pre-commit hooks
- Enables hooks for:
  - deadnix
  - statix
  - treefmt

To configure more pre-commit hooks, see the [git-hooks-nix documentation](https://flake.parts/options/git-hooks-nix.html).

## Usage

### Subflake

To avoid polluting the top-level flake inputs with development inputs, dev-flake can be used in a subflake.

#### Existing project

Within an existing project ([template](template/subflake)):

```sh
mkdir -p dev
cd dev
nix flake init -t github:terlar/dev-flake
```

Add the following to your flake-parts config:
```nix
# ...
imports = [ inputs.flake-parts.flakeModules.partitions ];

partitionedAttrs = {
  checks = "dev";
  devShells = "dev";
};

partitions.dev = {
  extraInputsFlake = ./dev;
  module = { imports = [ ./dev/flake-module.nix ]; };
};
# ...
```

#### New project

Create a new project ([template](template/subflake-project)):

```sh
mkdir -p project
nix flake init -t github:terlar/dev-flake#subflake-project
```

### Root flake

You can also use this flake in the root flake, when using flake-parts, all you need to do is import the flake.

```nix
{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    dev-flake.url = "github:terlar/dev-flake";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
      imports = [ inputs.dev-flake.flakeModule ];
      dev.name = "my-project";
    };
}
```

Within an existing project ([template](template/root)):

```sh
mkdir -p dev
cd dev
nix flake init -t github:terlar/dev-flake#root
```

Create a new project ([template](template/root-project)):

```sh
mkdir -p project
nix flake init -t github:terlar/dev-flake#root-project
```

## Examples
- [terlar/emacs-config](https://github.com/terlar/emacs-config)
- [terlar/nix-terraform](https://github.com/terlar/nix-terraform)
- [terlar/nix-config](https://github.com/terlar/nix-config)
