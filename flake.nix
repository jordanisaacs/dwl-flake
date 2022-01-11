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

          nativeBuildInputs = with pkgs; [
            pkg-config
          ];

          buildInputs = with pkgs; [
            libinput
            xorg.libxcb
            libxkbcommon
            pixman
            wayland
            wayland-protocols
            wlroots

            # xwayland
            xorg.libX11
            xwayland
          ];

          devInputs = with pkgs; [
            ccls
            bear
          ];

          dwlBuilder = { pkgs, lib ? pkgs.lib }: { config }:
            let
              options = pkgs.lib.evalModules {
                modules = [
                  { imports = [ ./module.nix ]; }
                  config
                ];

                specialArgs = {
                  inherit pkgs;
                };
              };

              cmdToC = cmd: with builtins; (concatStringsSep " " (map (x: ''\"'' + x + ''\",'') cmd)) + " NULL";
              cmds = builtins.mapAttrs (name: value: (cmdToC value)) options.config.cmds;
            in
            pkgs.stdenv.mkDerivation
              rec {
                pname = "dwl-jd";
                version = "0.1";

                inherit nativeBuildInputs buildInputs;

                src = ./.;

                postPatch = ''
                  substituteInPlace ./config.def.h --replace "\"@termcmd@\"" "${cmds.term}"
                  substituteInPlace ./config.def.h --replace "\"@menucmd@\"" "${cmds.menu}"
                  substituteInPlace ./config.def.h --replace "\"@audiodowncmd@\"" "${cmds.audiodown}"
                  substituteInPlace ./config.def.h --replace "\"@audioupcmd@\"" "${cmds.audioup}"
                  substituteInPlace ./config.def.h --replace "\"@audiomutcmd@\"" "${cmds.audiomut}"
                  substituteInPlace ./config.def.h --replace "\"@audiofrwcmd@\"" "${cmds.audiofrw}"
                  substituteInPlace ./config.def.h --replace "\"@audioprevcmd@\"" "${cmds.audioprev}"
                  substituteInPlace ./config.def.h --replace "\"@audioplaycmd@\"" "${cmds.audioplay}"
                '';

                installPhase = ''
                  runHook preInstall
                  install -d $out/bin
                  install -m755 dwl $out/bin
                  runHook postInstall
                '';
              };
        in
        rec {
          apps = {
            dwl = {
              type = "app";
              program = "${defaultPackage}/bin/dwl";
            };
          };

          overlay = (self: super: {
            dwlBuilder = dwlBuilder { inherit pkgs; };
          });

          packages.dwl = dwlBuilder { inherit pkgs; } {
            config = { };
          };

          defaultApp = apps.dwl;
          defaultPackage = packages.dwl;

          devShell = pkgs.mkShell {
            inherit nativeBuildInputs;
            buildInputs = buildInputs ++ devInputs;
          };
        }
      );
}
