{ config, lib, pkgs, ... }:
with lib;
with builtins;

let
  cfg = config.cmds;
in
{
  options.cmds = {
    term = mkOption {
      type = with types; listOf string;
      default = [ "${pkgs.foot}/bin/foot" ];
      description = "open terminal command";
    };

    menu = mkOption {
      type = with types; listOf string;
      default = [ "${pkgs.bemenu}/bin/bemenu-run" ];
      description = "open menu command";
    };

    audioup = mkOption {
      type = with types; listOf string;
      default = [ "" ];
      description = "vol up key command";
    };

    audiodown = mkOption {
      type = with types; listOf string;
      default = [ "" ];
      description = "vol down key command";
    };

    audiomut = mkOption {
      type = with types; listOf string;
      default = [ "" ];
      description = "vol mute key command";
    };

    audiofrw = mkOption {
      type = with types; listOf string;
      default = [ "" ];
      description = "audio forward key command";
    };

    audioprev = mkOption {
      type = with types; listOf string;
      default = [ "" ];
      description = "audio previous key command";
    };

    audioplay = mkOption {
      type = with types; listOf string;
      default = [ "" ];
      description = "audio play command";
    };
  };
}
