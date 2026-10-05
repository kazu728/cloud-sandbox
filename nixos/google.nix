{ lib, modulesPath, ... }:

{
  imports = [ "${modulesPath}/virtualisation/google-compute-image.nix" ];

  networking.hostName = "google";
  systemd.services."serial-getty@ttyS0".enable = true;
  security.googleOsLogin.enable = lib.mkForce false;

  # GCE metadata and DNS share this IP and must bypass the exit node.
  networking.localCommands = ''
    ip -4 rule del pref 100 to 169.254.169.254/32 lookup main 2>/dev/null || true
    ip -4 rule add pref 100 to 169.254.169.254/32 lookup main
  '';

  services.tailscale = {
    useRoutingFeatures = "client";
    extraSetFlags = [
      # Hostnames require a peer map that may be unavailable during boot.
      "--exit-node=100.109.47.87"
      "--exit-node-allow-lan-access"
    ];
  };
}
