{
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "codexbar-cookie-importer";
  version = "1.2";
  pyproject = true;

  src = python3Packages.fetchPypi {
    pname = "codexbar_cookie_importer";
    inherit version;
    hash = "sha256-Zmep9SCWcA7T7muvV29zzAtLvhEXarBcKi7zwWfYk7g=";
  };

  build-system = [ python3Packages.setuptools ];
  dependencies = with python3Packages; [
    cryptography
    secretstorage
  ];

  pythonImportsCheck = [ "codexbar_cookie_importer" ];

  meta = {
    description = "Import Chromium session cookies for CodexBar";
    homepage = "https://github.com/InledGroup/codexbar-gnome";
    license = lib.licenses.mit;
    mainProgram = "codexbar-cookie-importer";
  };
}
