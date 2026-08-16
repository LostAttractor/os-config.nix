{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # System information tool
    hyfetch
    fastfetch
    screenfetch
    cpufetch
    powertop
    bottom
    btop
    nvtopPackages.full
    # Terminal utils
    lolcat
    cmatrix
    # Alternative to ls/cat
    bat
    lsd
    # JSON filter
    jnv
    # Diff
    difftastic
    # Grep
    ripgrep
    # Find
    fd
    # B4
    b4
    # TLDR
    tldr
    pay-respects
    # File manager
    yazi
    # Screenshot
    grim
    slurp
    wl-clipboard
    # Network utils
    nali
    tcping-go
    gping
    stuntman
    # Spedtest utils
    ookla-speedtest
    cfspeedtest
    # Wireless utils
    iw
    # Web video downloader
    you-get
    yt-dlp
    # Viedo tool
    ffmpeg
    # Unzip
    p7zip
    # Desktop tools
    handlr
    xdotool
    # Netowrk tools
    iperf3
    nmap
    tcpdump
    pwru
    wgcf
    # Proxy
    v2ray
    xray
    sing-box
    tor
    (callPackage ./uudeck {})
    # IMPI
    ipmitool
    # Disk analayzer
    gdu
    duf
    # Develop Tools
    gh
    hugo
    devbox
    charm-freeze
    android-tools
    # Kubernetes
    kubectl
    kubectx
    kubernetes-helm
    helmfile
    k9s
    cilium-cli
    hubble
    argocd
    # Language Server
    nil
    # Nix Utils
    nix-output-monitor
    sops
    nurl
    nix-update
    attic-client
    # Wine
    wineWow64Packages.staging
    winetricks
    # Binary Analayzer
    file
    binwalk
    hexyl
    # Other utils
    openssl
    sshx
  ];
}
