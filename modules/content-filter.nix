{ ... }: {
  # Local dnsmasq sits between the system and CleanBrowsing.
  # Whitelisted domains resolve via Cloudflare (1.1.1.1); everything else
  # goes through the CleanBrowsing Family Filter.
  services.dnsmasq = {
    enable = true;
    settings = {
      no-resolv = true;
      listen-address = "127.0.0.1";
      bind-interfaces = true;
      server = [
        # --- Whitelist: bypass content filter for these domains ---
        "/anthropic.com/1.1.1.1"
        "/claude.ai/1.1.1.1"
        # ----------------------------------------------------------
        # Default upstream: CleanBrowsing Family Filter
        "185.228.168.168"
        "185.228.169.168"
      ];
    };
  };

  # Point the system at the local dnsmasq instance
  networking.nameservers = [ "127.0.0.1" ];
  networking.networkmanager.dns = "none";
}
