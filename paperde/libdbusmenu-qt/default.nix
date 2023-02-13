{ lib, stdenv, fetchFromGitHub, fetchgit, fetchpatch, cmake, qt6 }:

stdenv.mkDerivation rec {
  pname = "libdbusmenu-qt6";
  version = "0.9.3+16";

  src = fetchgit {
    url = "https://git.launchpad.net/ubuntu/+source/libdbusmenu-qt";
    rev = "import/${version}.04.20160218-2";
    sha256 = "039yvklhbmfbcynrbqq9n5ywmj8bjfslnkzcnwpzyhnxdzb6yxlx";
  };

  buildInputs = [ qt6.qtbase ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DWITH_DOC=OFF -DUSE_QT6=ON" ];

  prePatch = ''
    sed -e '/tests/d' -i CMakeLists.txt
  '';
  dontWrapQtApps = true;
  doCheck = false;
  patches = [
    (fetchpatch {
      name = "af9fa001.patch";
      url = "https://github.com/desktop-app/libdbusmenu-qt/commit/af9fa001.patch";
      sha256 = "sha256-+rKem31Dl8bHwUULSMh+7LYn1rR6liK96srPlWxxRMk=";
    })

    ./libdbusmenu-qt6-cmake.patch
  ];
}
