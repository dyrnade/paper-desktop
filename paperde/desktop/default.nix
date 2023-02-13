{ stdenv,
qt5ct, 
xdg-user-dirs, xwayland, wayqt, 
ipc, login1, status-notifier, applications, CuboCore, ninja, 
meson, fetchFromGitLab, xdg-desktop-portal, xdg-desktop-portal-kde, 
xdg-desktop-portal-gtk, xdg-desktop-portal-wlr, wayland, wayland-protocols, 
wayfire,
libcprime,
libcsys,
libdbusmenu-qt,
cmake, glib, python3, qt6 }:

# autoreconfHook
 stdenv.mkDerivation rec {
  name = "paper/paperde";
  version = "v0.2.1";
  src = ./.;
  outputs = [ "out" ];
  #mesonAutoFeatures = "auto";
  nativeBuildInputs = [
      ninja meson cmake python3
  ];
  
  buildInputs = [
       wayqt login1 status-notifier ipc applications libcprime libcsys wayfire
      libdbusmenu-qt
      qt6.full 
  ];
  passthru.providedSessions = [ "paperdesktop" ];
  mesonFlags = [ "--prefix=${placeholder "out"} --buildtype=release -Duse_qt_version=qt6" ];
  
  patches = [
    ./0001-fix-application-dirs.patch
  ];

  postPatch = ''
    substituteInPlace ./sessionmanager/paperdesktop.desktop --replace /usr/bin $out/bin
    #####substituteInPlace ./sessionmanager/paperdesktop.desktop --replace TryExec=/usr/bin/papersessionmanager TryExec="env WAYFIRE_CONFIG_FILE=$out/share/paperde/wayfire.ini $out/bin/papersessionmanager"
    substituteInPlace ./papershell/shell/papershell.conf --replace /usr/share/ $out/share
    substituteInPlace ./papershell/shell/papershell.conf --replace /usr/lib/coreapps/plugins $out/lib/paperde/plugins
    substituteInPlace ./sessionmanager/wayfire.ini.in --replace /usr/libexec/xdg-desktop-portal ${xdg-desktop-portal}/libexec/xdg-desktop-portal
    substituteInPlace ./sessionmanager/wayfire.ini.in --replace /usr/libexec/xdg-desktop-portal-wlr ${xdg-desktop-portal-wlr}/libexec/xdg-desktop-portal-wlr
    substituteInPlace ./settings/org.cubocore.PaperSettings.desktop --replace Exec=papersettings Exec=${placeholder "out"}/bin/papersettings
    mkdir -p $out/lib/paperde/plugins
    #ln -sf "${CuboCore.coreaction}/lib/coreapps/plugins" $out/lib/paperde/plugins
    for p in "${CuboCore.coreaction}/lib/coreapps/plugins/*" "${CuboCore.coretoppings}/lib/coreapps/plugins/*";
    do
      ln -sf $p $out/lib/paperde/plugins/$(basename $p)
    done
    #cp -s "${CuboCore.coreaction}/lib/coreapps/plugins/*" $out/lib/paperde/plugins
    #cp -s "${CuboCore.coretoppings}/lib/coreapps/plugins/*" $out/lib/paperde/plugins
  '';
}
