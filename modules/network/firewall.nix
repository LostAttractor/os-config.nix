{ pkgs, ... }: {
  networking.nftables.enable = true;
  environment.systemPackages = with pkgs; [ iptables ];
  networking.firewall.enable = false;
}
