{ modulesPath, ... }:

{
  imports = [ "${modulesPath}/virtualisation/google-compute-image.nix" ];

  systemd.services."serial-getty@ttyS0".enable = true;
}
