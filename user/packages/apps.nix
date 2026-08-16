{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # Terminal
    blackbox-terminal
    ghostty
    ptyxis
    warp-terminal
    waveterm
    # Web Browser
    google-chrome
    brave
    # Social Apps
    qq
    wechat
    discord
    dissent
    polari
    # Password Manager
    bitwarden-cli
    # Music
    gapless
    amberol
    ncmpcpp
    ncspot
    go-musicfox
    # RSS
    newsflash
    himalaya
    # Media
    komikku
    shortwave
    vlc
    (mpv.override { mpv-unwrapped = mpv-unwrapped.override { cddaSupport = true; }; })
    # Games
    umu-launcher
    protonplus
    osu-lazer-bin
    lunar-client
    (inputs.nixos-xivlauncher-rb.packages.${stdenv.hostPlatform.system}.default.override { useGameMode = true; })
    lutris
    bottles
    # AI
    codex
    chatgpt
    claude-code
    opencode
    (inputs.llm-agents.packages.${stdenv.hostPlatform.system}.opencode2)
    (inputs.codexbar.packages.${stdenv.hostPlatform.system}.codexbar-cli)
    (callPackage ./codexbar/cookie-importer.nix { })
    # Writing Tools
    rnote
    papers
    # Office Toolkits
    wpsoffice-cn
    # File Searching
    fsearch
    # Remote Desktop
    parsec-bin
    remmina
    moonlight-qt
    # Virt Manager
    virt-manager
    looking-glass-client
    # Radio
    gqrx
    # CAD
    kicad
    easyeda2kicad
    # Screenkey
    showmethekey
    # Uxplay
    uxplay
    # Backup
    pika-backup
    # Screenshot
    flameshot
    # Gnome Cicle Apps
    metadata-cleaner
    gnome-decoder
    video-trimmer
    raider
    dialect
    eyedropper
    collision
    # Dconf
    dconf-editor
    # Others
    deskflow
    uxplay
    cameractrls-gtk4
    roomeqwizard
    (callPackage ./tiny4linux {})
    ] ++ (with (import inputs.nixpkgs-stable {
      # https://discourse.nixos.org/t/how-do-i-configure-multiple-nixpkgss-in-flakes/59581/2
      inherit (stdenv.hostPlatform) system;
      inherit (pkgs) config;
    }); [ # Massively builds
    # Electron
    element-desktop
    signal-desktop
    bitwarden-desktop
    github-desktop
    # Qt
    telegram-desktop
    # Kdenlive
    kdePackages.kdenlive
    frei0r
    mediainfo
    # Browser
    chromium
    thunderbird
    # Rust
    rustdesk
    fractal
    # IDE
    lapce
    zed-editor
    # Other
    libreoffice
  ]);
}
