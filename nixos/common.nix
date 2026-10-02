{
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  services.tailscale.enable = true;

  # Rebuilds must apply the console hash after the first SSH login.
  users.mutableUsers = false;
  users.users.root.hashedPasswordFile = "/var/lib/cloud-sandbox/console-password-hash";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "26.05";
}
