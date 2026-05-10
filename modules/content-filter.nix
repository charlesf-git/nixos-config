{ ... }: {
  # CleanBrowsing Family Filter — blocks adult, pornographic, and proxy/VPN content
  networking.nameservers = [
    "185.228.168.168"
    "185.228.169.168"
  ];

  # Prevent NetworkManager from overwriting the DNS servers above
  networking.networkmanager.dns = "none";
}
