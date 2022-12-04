{
  config,
  lib,
  ...
}:
with lib; {
  options.cmds = {
    term = mkOption {
      type = with types; listOf string;
      default = ["foot"];
      description = "open terminal command";
    };

    menu = mkOption {
      type = with types; listOf string;
      default = ["bemenu-run"];
      description = "open menu command";
    };

    quit = mkOption {
      type = with types; listOf string;
      default = [];
      description = "open terminal command";
    };

    audioup = mkOption {
      type = with types; listOf string;
      default = [];
      description = "vol up key command";
    };

    audiodown = mkOption {
      type = with types; listOf string;
      default = [];
      description = "vol down key command";
    };

    audiomut = mkOption {
      type = with types; listOf string;
      default = [];
      description = "vol mute key command";
    };

    audiofrw = mkOption {
      type = with types; listOf string;
      default = [];
      description = "audio forward key command";
    };

    audioprev = mkOption {
      type = with types; listOf string;
      default = [];
      description = "audio previous key command";
    };

    audioplay = mkOption {
      type = with types; listOf string;
      default = [];
      description = "audio play command";
    };
  };
}
