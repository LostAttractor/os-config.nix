_: {
  programs.lazygit = {
    enable = true;
    settings.git = {
      overrideGpg = true;
      pagers = [
        {
          externalDiffCommand = "difft";
        }
      ];
    };
  };
}
