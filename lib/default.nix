{ pkgs, lib ? pkgs.lib, ... }:

{ config }:
let
  options = pkgs.lib.evalModules {
    modules = [
      { imports = [ ../modules ]; }
      config
    ];

    specialArgs = {
      inherit pkgs;
    };
  };

  cmdToC = cmd: with builtins; (concatStringsSep " " (map (x: ''\"'' + x + ''\",'') cmd)) + " NULL";
  cmds = builtins.mapAttrs (name: value: (cmdToC value)) options.config.cmds;
in
pkgs.dwl.overrideAttrs
  (oldAttrs: rec {
    version = "main";
    src = ../.;
    postPatch = ''
      substituteInPlace ./config.def.h --replace "@termcmd@" "${cmds.term}"
      substituteInPlace ./config.def.h --replace "@menucmd@" "${cmds.menu}"
      substituteInPlace ./config.def.h --replace "@audiodowncmd@" "${cmds.audiodown}"
      substituteInPlace ./config.def.h --replace "@audioupcmd@" "${cmds.audioup}"
      substituteInPlace ./config.def.h --replace "@audiomutcmd@" "${cmds.audiomut}"
      substituteInPlace ./config.def.h --replace "@audiofrwcmd@" "${cmds.audiofrw}"
      substituteInPlace ./config.def.h --replace "@audioprevcmd@" "${cmds.audioprev}"
      substituteInPlace ./config.def.h --replace "@audioplaycmd@" "${cmds.audioplay}"
    '';

    NIX_CFLAGS_COMPILE = "-Wno-error=unused-result";
  })
