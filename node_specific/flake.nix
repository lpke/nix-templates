{
  description = "node project dev shell - specific version";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-node.url = "github:NixOS/nixpkgs/<COMMIT-HASH>"; # https://www.nixhub.io/packages/nodejs
    # nixpkgs-node.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # for latest node
  };

  outputs = { self, nixpkgs, nixpkgs-node }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f {
        inherit system;
        pkgs = import nixpkgs { inherit system; };
        pkgsNode = import nixpkgs-node { inherit system; };
      });
    in {
      devShells = forAllSystems ({ pkgs, pkgsNode, ... }: {
        default = pkgs.mkShell {
          packages = [
            pkgsNode.nodejs
            # pkgsNode.nodejs_latest # with nixpkgs-node = nixpkgs-unstable
            pkgs.pnpm
            # (pkgs.pnpm.override { nodejs = pkgsNode.nodejs_latest; })
          ];
          shellHook = ''
            # project-specific env here
          '';
        };
      });
    };
}
