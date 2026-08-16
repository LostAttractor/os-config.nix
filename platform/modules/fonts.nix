{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      # Cantarell font
      cantarell-fonts
      # Inter font
      inter
      # Noto Fonts
      noto-fonts
      noto-fonts-color-emoji
      # 思源宋体/思源黑体 (CJK Fonts)
      # Variable-fonts may cause some apps to not render CJK correctly
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      # So also install non-variable version
      source-han-sans
      source-han-serif
      source-han-mono
      # Monospace fonts
      fira-code
      fira-code-symbols
      nerd-fonts.fira-code
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      hack-font
      nerd-fonts.hack
      nerd-fonts.droid-sans-mono
      # 微软雅黑/正黑
      vista-fonts
      vista-fonts-cht
      vista-fonts-chs
      # 文泉驿
      wqy_microhei
      wqy_zenhei
      # Some unused fonts
      # Source fonts
      # source-sans-pro
      # source-serif-pro
      # source-code-pro
      # 更纱黑体
      # sarasa-gothic
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = [
          # Main Sans-Serif Font 
          "Cantarell"
          # CJK Fallback
          "Noto Sans CJK SC"
          "Noto Sans CJK TC"
          "Noto Sans CJK JP"
          "Noto Sans CJK KR"
          # Unicode Fallback
          "DejaVu Sans"
        ];
        serif = [
          # Main Serif Font
          "Noto Serif"
          # CJK Fallback
          "Noto Serif CJK SC"
          "Noto Serif CJK TC"
          "Noto Serif CJK JP"
          "Noto Serif CJK KR"
          # Unicode Fallback
          "DejaVu Serif"
        ];
        monospace = [
          # Main Mono Font
          "JetBrainsMono"
          # CJK Fallback
          "Noto Sans Mono CJK SC"
          "Noto Sans Mono CJK TC"
          "Noto Sans Mono CJK JP"
          "Noto Sans Mono CJK KR"
          # Unicode Fallback
          "DejaVu Sans Mono"
        ];
        emoji = [ "Noto Color Emoji" ];
      };

      subpixel.rgba = "rgb";
    };
  };
}
