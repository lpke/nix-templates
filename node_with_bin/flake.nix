{
  description = "node project dev shell with local bin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    # FOR SPECIFIC OR LATEST NODE:
    # nixpkgs-node.url = "github:NixOS/nixpkgs/<COMMIT-HASH>"; # https://www.nixhub.io/packages/nodejs
    # nixpkgs-node.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # for latest node
  };

  outputs = { self, nixpkgs }:
  # outputs = { self, nixpkgs, nixpkgs-node }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f {
        inherit system;
        pkgs = import nixpkgs { inherit system; };
        # pkgsNode = import nixpkgs-node { inherit system; };
      });
    in {
      devShells = forAllSystems ({ pkgs, ... }: {
      # devShells = forAllSystems ({ pkgs, pkgsNode, ... }: {
        default = pkgs.mkShell {
          packages = [
            pkgs.nodejs
            # FOR SPECIFIC OR LATEST NODE:
            # pkgsNode.nodejs
            # pkgsNode.nodejs_latest # with nixpkgs-node = nixpkgs-unstable
            pkgs.pnpm
            # FOR SPECIFIC OR LATEST NODE:
            # (pkgs.pnpm.override { nodejs = pkgsNode.nodejs_latest; })
          ];

          shellHook = ''
            # Project-local bin directory for scripts and tools
            export PATH="$PWD/.flake.local/bin:$PATH"
          '';
        };
      });
    };
}
