{
  lib,
  fetchpatch2,
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

  patches = [
    (fetchpatch2 {
      # Read Chromium ciphertext as bytes even when SQLite stores it as TEXT.
      url = "https://github.com/LostAttractor/codexbar-gnome/commit/fc6aa3365335aae9a85747d33af76563f26f6e1f.patch";
      hash = "sha256-v+jqHEWmZpIEpqapP17Hu7Q/mu4n+rvJHXd7hykJQLU=";
    })
  ];
  patchFlags = [ "-p2" ]; # Strip the repository's cookie_importer_package/ prefix.

  build-system = [ python3Packages.setuptools ];
  dependencies = with python3Packages; [
    cryptography
    secretstorage
  ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];
  pytestFlags = [ "tests" ];
  pythonImportsCheck = [ "codexbar_cookie_importer" ];

  meta = {
    description = "Import Chromium session cookies for CodexBar";
    homepage = "https://github.com/InledGroup/codexbar-gnome";
    license = lib.licenses.mit;
    mainProgram = "codexbar-cookie-importer";
  };
}
