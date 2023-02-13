{ stdenv, ninja, meson, fetchFromGitLab, cmake, python3, pkgconfig, qt6 }:
 stdenv.mkDerivation rec {
  pname = "login1";
  version = "test";
  src = fetchFromGitLab {
    hash = "sha256-LGEyRKOAgc9wMdAxMJ4Q6Dl/a0ikyVW7f/LQte5gLJI=";
    domain = "gitlab.com";
    owner = "dyrnade";
    repo = pname;
    rev = version;
  };
  outputs = [ "out" ];

  nativeBuildInputs = [
      ninja meson cmake python3 pkgconfig
  ];
  
  buildInputs = [
      qt6.full  pkgconfig
  ];
  mesonFlags = [ "--prefix=${placeholder "out"}/usr --buildtype=release -Duse_qt_version=qt6" ];
}