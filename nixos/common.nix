{
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  services.tailscale.enable = true;

  # Verify the initial SSH host key through the cloud's serial console.
  systemd.services.sshd-keygen.serviceConfig.StandardOutput = "journal+console";

  # Rebuilds must apply the console hash after the first SSH login.
  users.mutableUsers = false;
  users.users.root.hashedPasswordFile = "/var/lib/cloud-sandbox/console-password-hash";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "26.05";
}
