# See https://nixos.wiki/wiki/Qt#Packaging
# See https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=powerkit
{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  xorg,
  qtbase,
  wrapQtAppsHook,
  xscreensaver,
}:
  stdenv.mkDerivation {
    pname = "powerkit";
    version = "1.0.0";
    buildInputs = [
      qtbase
      xorg.libX11
      xorg.libXrandr
      xorg.libXScrnSaver
    ];
    nativeBuildInputs = [
      wrapQtAppsHook
    ];
    src = fetchFromGitHub {
      owner = "rodlie";
      repo = "powerkit";
      rev = "8b4ec653388103d6e9ff577f905ae957a7f625a6";
      hash = "sha256-aToCHdOlMP+q0iD/DAyWaKsTVaWTuxyeNxWIVGNyFpY=";
    };
    buildPhase = ''
      mkdir ./build
      cd ./build
      mkdir $out
      qmake PREFIX=/ CONFIG+=install_udev_rules CONFIG+=bundle_icons ..
      make
    '';
    installPhase = ''
      make INSTALL_ROOT=$out install
    '';
    postFixup = ''
      substituteInPlace $out/etc/udev/rules.d/90-backlight.rules \
        --replace-fail /bin/chgrp ${coreutils}/bin/chgrp \
        --replace-fail /bin/chmod ${coreutils}/bin/chmod
      wrapProgram $out/bin/powerkit \
        --prefix PATH : ${lib.makeBinPath [
          xscreensaver
        ]}
    '';
  }

