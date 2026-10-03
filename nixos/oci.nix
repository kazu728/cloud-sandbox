{ modulesPath, ... }:

{
  imports = [ "${modulesPath}/virtualisation/oci-image.nix" ];

  networking.hostName = "oci";

  services.tailscale = {
    useRoutingFeatures = "server";
    extraSetFlags = [ "--advertise-exit-node" ];
  };
}
