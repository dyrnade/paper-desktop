{ stdenv, lib, fetchFromGitLab, udisks2, qt6, cmake, ninja }:

stdenv.mkDerivation rec {
  pname = "libcsys";
  version = "test";

  src = fetchFromGitLab {
    owner = "dyrnade";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-/iRFppe08+rMQNFjWSyxo3Noy0iNaelg0JAczg/BYBs=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  dontWrapQtApps = true;
  buildInputs = [
    qt6.qtbase
    udisks2
  ];
  cmakeFlags = [ "-DUSE_QT6=ON" ];
}
