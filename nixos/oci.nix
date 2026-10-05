{ modulesPath, ... }:

{
  imports = [ "${modulesPath}/virtualisation/oci-image.nix" ];

  networking.hostName = "oci";
  systemd.services.fetch-ssh-keys.enable = false;

  services.tailscale = {
    useRoutingFeatures = "server";
    extraSetFlags = [ "--advertise-exit-node" ];
  };
}
