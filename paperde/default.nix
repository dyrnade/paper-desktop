{ pkgs, makeScope, qt6 }:
let
  packages = self: with self; {

    login1 = callPackage ./login1 {  };
    ipc = callPackage ./ipc { };
    status-notifier = callPackage ./status-notifier {  };
    wayqt = callPackage ./wayqt { };
    applications = callPackage ./applications { inherit ipc; };
    libdbusmenu-qt = callPackage ./libdbusmenu-qt { };
    libcsys = callPackage ./libcsys { };
    libcprime = callPackage ./libcprime { };
    paperde-desktop = callPackage ./desktop { inherit libdbusmenu-qt libcprime libcsys wayqt status-notifier ipc applications login1; };

    corePackages = [
      ### BASE
      login1
      ipc
      status-notifier
      wayqt
      applications
      paperde-desktop
    ];
  };
in
makeScope qt6.newScope packages