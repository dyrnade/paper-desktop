{ stdenv
, lib
, fetchFromGitLab
, libnotify
, cmake
, ninja
, qt6
  #, qtconnectivity
}:

stdenv.mkDerivation rec {
  pname = "libcprime";
  version = "test";

  src = fetchFromGitLab {
    owner = "dyrnade";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-0RgNcMEA4qP7UiRG9x/xdazlL7PsBnqv4raIa86ceSU=";
  };

  dontWrapQtApps = true;

  #patches = [
  #  ./0001-fix-application-dirs.patch
  #];

  cmakeFlags = [ "-DUSE_QT6=ON" ];
  mesonFlags = [ "--buildtype=release  -Duse_qt_version=qt6 -DUSE_QT6=ON" ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtconnectivity
    libnotify
  ];

  meta = with lib; {
    description = "A library for bookmarking, saving recent activites, managing settings of C-Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/libcprime";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
