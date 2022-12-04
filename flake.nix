{
  description = "A very basic flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";

    pkgs = nixpkgs.legacyPackages.${system};

    dwlBuilder = pkgs.callPackage ./lib {
      stdenv = pkgs.stdenvAdapters.keepDebugInfo pkgs.stdenv;
      inherit (pkgs.xorg) xcbutilwm;
    };
    dwlPkg = dwlBuilder {config = {};};
    dwlApp = {
      type = "app";
      program = "${dwlPkg}/bin/dwl";
    };
  in {
    apps.${system} = {
      default = dwlApp;
      dwl = dwlApp;
    };

    overlays.default = final: prev: {
      inherit dwlBuilder;
      dwlJD = dwlPkg;
    };

    packages.${system} = {
      default = dwlPkg;
      dwl = dwlPkg;
    };

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = dwlPkg.buildInputs;
      nativeBuildInputs =
        dwlPkg.nativeBuildInputs
        ++ [
          pkgs.bear
        ];
    };
  };
}
