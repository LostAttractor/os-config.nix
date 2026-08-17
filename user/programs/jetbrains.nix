{ pkgs, ... }:
{
  home.packages = with pkgs.jetbrains; [
    idea
    clion
    pycharm
    goland
    rust-rover
  ];
}
