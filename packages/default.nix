{ pkgs, ... }:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Download Tools
    wget
    axel
    # Editor & VCS
    git
    vim
    nano
    # Basic Tools
    htop
    tmux
    lsof
    # Performance
    perf
    # Devices
    pciutils
    usbutils
    smartmontools
    # Network
    inetutils
    bridge-utils
    dnsutils
    ethtool
    trippy
    q
    dogdns
    # Graphics
    vulkan-tools
    mesa-demos
    # Video Codec
    libva-utils
    # Audio
    alsa-utils
    # Sensors
    lm_sensors
    # Rsync
    rsync
    # Compiler
    gnumake
    bison
    flex
    clang
    clang-tools
    go
    rustup
    gcc
    gdb
    # Runtime
    nodejs
    pnpm
    yarn
    python3
  ];
}
