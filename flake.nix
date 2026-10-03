{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { self, nixpkgs, ... }: {
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

    # Hosted ARM runners lack KVM; the standard QEMU command falls back to TCG.
    packages.aarch64-linux.oci-image =
      nixpkgs.lib.overrideDerivation self.nixosConfigurations.oci.config.system.build.image
        (_: {
          requiredSystemFeatures = [ ];
        });
  };
}
