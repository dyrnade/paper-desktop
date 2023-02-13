{ stdenv, ninja, meson, ipc, fetchFromGitLab, pkgconfig, cmake, glib, python3, qt6 }:
# autoreconfHook
 stdenv.mkDerivation rec {
  pname = "applications";
  version = "test";
  # https://gitlab.com/desktop-frameworks/ipc.git
  src = fetchFromGitLab {
    hash = "sha256-P5KOqsOKnGXhGiU4solykGym69m8s5yFY5WBRE3ZIFw=";
    domain = "gitlab.com";
    owner = "dyrnade";
    repo = pname;
    rev = version;
  };
  outputs = [ "out" ];
  #mesonAutoFeatures = "auto";
  nativeBuildInputs = [
    ninja meson pkgconfig cmake python3 qt6.wrapQtAppsHook ipc
  ];
  buildInputs = [
    glib 
    qt6.qtbase
  ];
  mesonFlags = [ "--prefix=${placeholder "out"}/usr --buildtype=release -Duse_qt_version=qt6" ];
}
