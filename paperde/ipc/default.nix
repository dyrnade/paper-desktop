{ stdenv, ninja, meson, fetchFromGitLab, pkgconfig, cmake, python3, qt6 }:
# autoreconfHook
stdenv.mkDerivation rec {
  pname = "ipc";
  version = "test";
  src = fetchFromGitLab {
    hash = "sha256-iafhHhwbZf72BAqRcqGEl6jWlwyfjCzLYvRFoeNITz8=";
    domain = "gitlab.com";
    owner = "dyrnade";
    repo = pname;
    rev = version;
  };
  outputs = [ "out" ];

  nativeBuildInputs = [
    ninja
    meson
    pkgconfig
    cmake
    python3
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    qt6.qtbase
  ];

  mesonFlags = [ "--prefix=${placeholder "out"}/usr --buildtype=release  -Duse_qt_version=qt6" ];
}
