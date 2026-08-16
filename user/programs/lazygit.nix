_: {
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        overrideGpg = true;
        diffRenderers = [
          {
            command = "difft";
            type = "extDiff";
          }
        ];
      };
    };
  };
}
