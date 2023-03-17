{
  description = "Pandoc Markdown filter that provides a Markdown extension that supports text wrapping in table cells.";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        packages = rec {
          pandoc-linear-table = pkgs.haskellPackages.developPackage {
            name = "pandoc-linear-table";
            root = ./.;
          };
          default = pandoc-linear-table;
        };
        apps = rec {
          pandoc-linear-table = flake-utils.lib.mkApp { drv = self.packages.${system}.pandoc-linear-table; };
          default = pandoc-linear-table;
        };
      }
    );
}
