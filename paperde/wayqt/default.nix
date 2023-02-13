{ stdenv, ninja, meson, fetchFromGitLab, wayland, wayland-protocols, pkgconfig, cmake, python3, qt6 }:
# autoreconfHook
 stdenv.mkDerivation rec {
  pname = "wayqt";
  version = "test";
  # https://gitlab.com/desktop-frameworks/ipc.git
  src = fetchFromGitLab {
    hash = "sha256-PL8XMddOtHsxgT6maDXMDvbHp2oW8CsMeKVtIAlmq7w=";
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
