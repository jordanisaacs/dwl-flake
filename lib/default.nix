{
  lib,
  stdenv,
  libinput,
  libxcb,
  libxkbcommon,
  pixman,
  pkg-config,
  wayland,
  wayland-protocols,
  wlroots_0_16,
  xwayland,
  libX11,
  xcbutilwm,
}: {config}: let
  options = lib.evalModules {
    modules = [
      {imports = [../modules];}
      config
    ];
  };

  cmdToC = cmd:
    with builtins;
      if cmd == []
      then "0"
      else (concatStringsSep " " (map (x: ''\"'' + x + ''\",'') cmd)) + " NULL";
  cmds = builtins.mapAttrs (name: value: (cmdToC value)) options.config.cmds;
in
  stdenv.mkDerivation {
    pname = "dwl";
    version = "unstable";

    src = ../.;

    nativeBuildInputs = [pkg-config];

    buildInputs = [
      libinput
      libxcb
      libxkbcommon
      pixman
      wayland
      wayland-protocols
      wlroots_0_16
      libX11
      xwayland
      xcbutilwm
    ];

    patches = [../patches/module.patch];

    postPatch = ''
      substituteInPlace ./config.def.h --replace "@termcmd@" "${cmds.term}"
      substituteInPlace ./config.def.h --replace "@menucmd@" "${cmds.menu}"
      substituteInPlace ./config.def.h --replace "@quitcmd@" "${cmds.quit}"
      substituteInPlace ./config.def.h --replace "@audioupcmd@" "${cmds.audioup}"
      substituteInPlace ./config.def.h --replace "@audiomutcmd@" "${cmds.audiomut}"
      substituteInPlace ./config.def.h --replace "@audiofrwcmd@" "${cmds.audiofrw}"
      substituteInPlace ./config.def.h --replace "@audioprevcmd@" "${cmds.audioprev}"
      substituteInPlace ./config.def.h --replace "@audiodowncmd@" "${cmds.audiodown}"
      substituteInPlace ./config.def.h --replace "@audioplaycmd@" "${cmds.audioplay}"
    '';

    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      install -d $out/bin
      install -m755 dwl $out/bin
      runHook postInstall
    '';

    meta = with lib; {
      homepage = "https://github.com/djpohly/dwl/";
      description = "Dynamic window manager for Wayland";
      longDescription = ''
        dwl is a compact, hackable compositor for Wayland based on wlroots. It is
        intended to fill the same space in the Wayland world that dwm does in X11,
        primarily in terms of philosophy, and secondarily in terms of
        functionality. Like dwm, dwl is:
        - Easy to understand, hack on, and extend with patches
        - One C source file (or a very small number) configurable via config.h
        - Limited to 2000 SLOC to promote hackability
        - Tied to as few external dependencies as possible
      '';
      license = licenses.gpl3Only;
      maintainers = with maintainers; [AndersonTorres];
      inherit (wayland.meta) platforms;
    };
  }
