{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    { self, nixpkgs, ... }:
    let
      # Cloud-console authentication protects passwordless login during initial setup.
      bootstrapImage =
        host:
        (self.nixosConfigurations.${host}.extendModules {
          modules = [
            {
              users.users.root = {
                hashedPasswordFile = nixpkgs.lib.mkForce null;
                hashedPassword = "";
              };
            }
          ];
        }).config.system.build.image;
    in
    {
      nixosConfigurations = {
        google = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos/common.nix
            ./nixos/google.nix
          ];
        };

        oci = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./nixos/common.nix
            ./nixos/oci.nix
          ];
        };
      };

      packages.x86_64-linux.google-image = bootstrapImage "google";

      # Hosted ARM runners lack KVM; the standard QEMU command falls back to TCG.
      packages.aarch64-linux.oci-image = nixpkgs.lib.overrideDerivation (bootstrapImage "oci") (_: {
        requiredSystemFeatures = [ ];
      });
    };
}
