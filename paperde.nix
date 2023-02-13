{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.paperde;

in

{
  meta = {
    maintainers = teams.lumina.members;
  };

  options = {

    services.xserver.desktopManager.paperde.enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Enable the Paperde desktop manager";
    };

  };


  config = mkIf cfg.enable {

    services.xserver.displayManager.sessionPackages = [
      pkgs.paperde.paperde-desktop
    ];

    environment.systemPackages =
      pkgs.paperde.corePackages;
    
    environment.sessionVariables.WAYFIRE_CONFIG_FILE = "${pkgs.paperde.paperde-desktop}/share/paperde/wayfire.ini";
    environment.sessionVariables.QT_QPA_PLATFORM = "wayland";
    
    # Link some extra directories in /run/current-system/software/share
    environment.pathsToLink = [
      # FIXME: modules should link subdirs of `/share` rather than relying on this
      "/share"
    ];

  };
}
