{ stdenv, ninja, meson, fetchFromGitLab, wayland, wayland-protocols, pkgconfig, cmake, python3, qt6 }:
# autoreconfHook
 stdenv.mkDerivation rec {
  pname = "wayqt";
  version = "test";
  # https://gitlab.com/desktop-frameworks/ipc.git
  src = fetchFromGitLab {
    hash = "sha256-QFm/tk7UlpzQTUGbX6dLE8vilRNFRzym/Ah75fb71PU=";
    domain = "gitlab.com";
    owner = "dyrnade";
    repo = pname;
    rev = version;
  };
  outputs = [ "out" ];


  nativeBuildInputs = [
    ninja meson pkgconfig cmake python3 qt6.wrapQtAppsHook wayland wayland-protocols
  ];
  buildInputs = [
    qt6.qtbase
  ];
  mesonFlags = [ "--prefix=${placeholder "out"}/usr --buildtype=release -Duse_qt_version=qt6" ];
}
