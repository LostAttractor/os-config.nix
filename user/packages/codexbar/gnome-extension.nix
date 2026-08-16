{
  lib,
  stdenvNoCC,
  fetchzip,
  glib,
}:

stdenvNoCC.mkDerivation {
  pname = "gnome-shell-extension-codexbar";
  version = "22";

  src = fetchzip {
    url = "https://extensions.gnome.org/extension-data/codexbarinled.es.v22.shell-extension.zip";
    hash = "sha256-gkxwGst3wW8QyKkYKpPEF/rmPlFmt+GuAVmeKEPFz80=";
    stripRoot = false;
  };

  nativeBuildInputs = [ glib ];

  postPatch = ''
    substituteInPlace adapters/CliSubprocessFetcher.js \
      --replace-fail \
        'let executable = "/home/linuxbrew/.linuxbrew/bin/codexbar";' \
        'let executable = GLib.find_program_in_path("codexbar") || "/run/current-system/sw/bin/codexbar";'

    substituteInPlace prefs.js \
      --replace-fail \
        'defaultCommand: "codexbar --provider claude --source cli --format json",' \
        'defaultCommand: "codexbar --provider claude --source oauth --format json",'
  '';

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas --strict schemas
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -d "$out/share/gnome-shell/extensions/codexbar@inled.es"
    cp -R . "$out/share/gnome-shell/extensions/codexbar@inled.es/"
    runHook postInstall
  '';

  passthru.extensionUuid = "codexbar@inled.es";

  meta = {
    description = "Show AI provider usage metrics in the GNOME panel";
    homepage = "https://github.com/InledGroup/codexbar-gnome";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
