{
  description = "A very basic flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs =
    { self
    , nixpkgs
    }:
    let
      system = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages.${system};
      wlroots = pkgs.wlroots.overrideAttrs (oa: {
        src = pkgs.fetchFromGitLab {
          domain = "gitlab.freedesktop.org";
          owner = "wlroots";
          repo = "wlroots";
          rev = "0.17.0";
          hash = "sha256-VUrnSG4UAAH0cBy15lG0w8RernwegD6lkOdLvWU3a4c=";
        };
        buildInputs = with pkgs; oa.buildInputs ++ [
          hwdata
          libliftoff
          libdisplay-info
        ];
      });

      dwlBuilder = pkgs.callPackage ./lib {
        stdenv = pkgs.stdenvAdapters.keepDebugInfo pkgs.stdenv;
        inherit (pkgs.xorg) xcbutilwm;
        inherit wlroots;
      };
      dwlPkg = dwlBuilder { config = { }; };
      dwlApp = {
        type = "app";
        program = "${dwlPkg}/bin/dwl";
      };
    in
    {
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
