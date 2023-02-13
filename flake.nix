{
  description = "paperde flake";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs?ref=nixos-unstable;
  };
  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = [
      "x86_64-linux"
    ];
    genSystems = nixpkgs.lib.genAttrs supportedSystems;
    pkgs = genSystems (system: import nixpkgs {inherit system;});
    paperdes = self.callPackage ./paperde { };
  in {
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
