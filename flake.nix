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
        paperde = pkgs.callPackage ./paperde { makeScope = pkgs.lib.makeScope; };
        x86_64-linux.paperde = paperde;
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
            paperdes = pkgs.callPackage ./paperde { makeScope = lib.makeScope; };
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
