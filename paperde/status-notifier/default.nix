{ stdenv, ninja, meson, fetchFromGitLab, cmake, python3, pkgconfig, qt6 }:
# autoreconfHook
 stdenv.mkDerivation rec {
  pname = "status-notifier";
  version = "test";
  src = fetchFromGitLab {
    hash = "sha256-xNq7elaj+deDPKlm8BSDdP0PpCtn9WC919AK7Hvh10g=";
    domain = "gitlab.com";
    owner = "dyrnade";
    repo = pname;
    rev = version;
  };
  outputs = [ "out" ];
  #mesonAutoFeatures = "auto";

  nativeBuildInputs = [
      ninja meson cmake python3 pkgconfig
  ];
  
  buildInputs = [
      qt6.full 
  ];
  
  mesonFlags = [ "--prefix=${placeholder "out"}/usr --buildtype=release -Duse_qt_version=qt6" ];
}
