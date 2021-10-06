{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };

          dwlBuilder = import ./lib { inherit pkgs; };

        in
        rec {
          apps = {
            dwl = {
              type = "app";
              program = "${defaultPackage}/bin/dwl";
            };
          };

          overlay = (self: super: {
            inherit dwlBuilder;
          });

          packages.dwl = dwlBuilder {
            config = { };
          };
          defaultApp = apps.dwl;
          defaultPackage = packages.dwl;
        }
      );
}
