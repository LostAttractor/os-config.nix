{ pkgs, inputs, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default.extensions = (with pkgs.vscode-marketplace; [
      jnoortheen.nix-ide
      ms-vscode.makefile-tools
      ms-vscode.cpptools-extension-pack
      ms-vscode.cmake-tools
      twxs.cmake
      golang.go
      redhat.vscode-yaml
      ms-vscode.hexeditor
      dakara.transformer
      github.vscode-pull-request-github
      github.vscode-github-actions
      ms-azuretools.vscode-docker
      ms-kubernetes-tools.vscode-kubernetes-tools
      ms-vscode-remote.remote-ssh-edit
      ms-vscode.remote-explorer
      github.copilot
      antfu.slidev
      openai.chatgpt
      # Theme
      pkief.material-icon-theme
      zhuangtongfa.material-theme
      # Lang
      ms-ceintl.vscode-language-pack-zh-hans
    ]) ++ (with ((import inputs.nixpkgs-stable {
      # https://discourse.nixos.org/t/how-do-i-configure-multiple-nixpkgss-instances-in-flakes/59581/2
      inherit (pkgs.stdenv.hostPlatform) system;
      config = pkgs.config;
    }).vscode-extensions); [
      eamodio.gitlens
      ms-python.python
      ms-vscode.cpptools
      rust-lang.rust-analyzer
      ms-vscode-remote.remote-ssh
      ms-vsliveshare.vsliveshare
    ]);
  };
}
