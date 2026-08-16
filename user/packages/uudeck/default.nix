{ stdenv, fetchzip, makeWrapper }:

let workdir = "/var/lib/uudeck"; in

stdenv.mkDerivation rec {
  pname = "uudeck";
  version = "9.8.8";
  src = fetchzip {
    url = "https://uurouter.gdl.netease.com/uuplugin/steam-deck-plugin-x86_64/v${version}/uu.tar.gz";
    hash = "sha256-tYnaqeAshbWUj79ZJb1OwlhcEaBi5DDK9pcs5xPKzKs=";
    stripRoot = false;
  };
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/{share/uudeck,bin}
    mv * $out/share/uudeck
    makeWrapper $out/share/uudeck/uuplugin $out/bin/uudeck \
      --run "! [ -d ${workdir} ] && { mkdir -p ${workdir}; cp $out/share/uudeck/uu.conf ${workdir}; }" \
      --chdir ${workdir}
  '';
}