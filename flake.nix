{
  description = "paperde flake";
    
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs?ref=d840126a0890621e7b220894d749132dd4bde6a0;
    #nixpkgs.url = github:NixOS/nixpkgs?ref=nixos-unstable;
  };
  outputs =
    { self
    , nixpkgs
    ,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    rec {
      packages = rec {
        login1 = pkgs.callPackage ./paperde/login1 { };
        ipc = pkgs.callPackage ./paperde/ipc { };
        status-notifier = pkgs.callPackage ./paperde/status-notifier { };
        wayqt = pkgs.callPackage ./paperde/wayqt { };
        applications = pkgs.callPackage ./paperde/applications { inherit ipc; };
        libdbusmenu-qt = pkgs.callPackage ./paperde/libdbusmenu-qt { };
        qt6ct = pkgs.qt6.callPackage ./paperde/qt6ct { };
        libcsys = pkgs.callPackage ./paperde/libcsys { };
        libcprime = pkgs.callPackage ./paperde/libcprime { };
        paper-desktop = pkgs.callPackage ./paperde/desktop { inherit libdbusmenu-qt libcprime libcsys wayqt status-notifier ipc applications login1; };

        x86_64-linux.login1 = login1;
        x86_64-linux.ipc = ipc;
        x86_64-linux.status-notifier = status-notifier;
        x86_64-linux.wayqt = wayqt;
        x86_64-linux.libdbusmenu-qt = libdbusmenu-qt;
        x86_64-linux.qt6ct = qt6ct;
        x86_64-linux.libcsys = libcsys;
        x86_64-linux.libcprime = libcprime;
        x86_64-linux.applications = applications;
        x86_64-linux.paper-desktop = paper-desktop;
        x86_64-linux.default = paper-desktop;
      };
       nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
         inherit system;
         modules = [
           nixosModules.paperde-desktop
           ./configuration.nix
         ];
       };
      nixosModules.paperde-desktop =
        { config
        , lib
        , options
        , pkgs
        , ...
        }:
          with lib; let
            xcfg = config.services.xserver;
            cfg = xcfg.desktopManager.paperde;
          in
          {
            options = {
              services.xserver.desktopManager.paperde.enable = mkOption {
                type = types.bool;
                default = false;
                description = lib.mdDoc "Enable the Paperde desktop manager";
              };
            };

            config = mkIf cfg.enable {

              services.xserver.displayManager.sessionPackages = [
                packages.paper-desktop
              ];
              
              environment.systemPackages = [
                packages.paper-desktop pkgs.wayfire packages.qt6ct pkgs.breeze-icons
               ];
              environment.sessionVariables.WAYFIRE_CONFIG_FILE = "${packages.paper-desktop}/share/paperde/wayfire.ini";
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
