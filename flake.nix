{
  description = "paperde flake";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs?ref=nixos-unstable;
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = {
    self,
    nixpkgs,
  }: 
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      lib = pkgs.lib;
      paperdes = pkgs.callPackage ./paperde {};
    in rec {
    formatter = genSystems (system: pkgs.${system}.nixos);
    nixosModules.paperde-desktop = {
      config,
      lib,
      options,
      pkgs,
      ...
    }:
      with lib; let
        xcfg = config.services.xserver;
        cfg = xcfg.desktopManager.paperde;
      in {
        options = {
          services.xserver.desktopManager.paperde.enable = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc "Enable the Paperde desktop manager";
          };
        };

        config = mkIf cfg.enable {

          services.xserver.displayManager.sessionPackages = [
            paperdes.paperde-desktop
          ];

          environment.systemPackages =
            paperdes.corePackages;
          
          environment.sessionVariables.WAYFIRE_CONFIG_FILE = "${paperdes.paperde-desktop}/share/paperde/wayfire.ini";
          environment.sessionVariables.QT_QPA_PLATFORM = "wayland";
          
          # Link some extra directories in /run/current-system/software/share
          environment.pathsToLink = [
            # FIXME: modules should link subdirs of `/share` rather than relying on this
            "/share"
          ];

        };
      };
  };
}
