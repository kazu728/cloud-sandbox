{ lib, ... }:

{
  services.openssh.enable = lib.mkForce false;
  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--ssh" ];
  };

  users.mutableUsers = false;
  users.users.root.hashedPasswordFile = "/var/lib/cloud-sandbox/console-password-hash";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "26.05";
}
