{ stdenv, lib, pkgs, fetchFromGitHub }:

let
  commit = "ef066167a4f3c0b799f861b5bcc86235d1e09d1a";
  sha256 = "0gg4g7zrn6mjixrjksv4flzxjg3jgvwz4qm2805k4j42w4ynb1wz";
in stdenv.mkDerivation rec {
  pname = "gopro-as-webcam";
  version = commit;

  src = fetchFromGitHub {
    owner = "jschmid1";
    repo = "gopro_as_webcam_on_linux";
    rev = commit;
    sha256 = sha256;
  };

  phases = "installPhase";
  installPhase = ''
    mkdir -p $out/bin/
    ln -s $src/gopro $out/bin/gopro
  '';
}
