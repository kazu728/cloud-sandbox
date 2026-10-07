{ modulesPath, ... }:

{
  imports = [ "${modulesPath}/virtualisation/oci-image.nix" ];

  networking.hostName = "oci";
  systemd.services.fetch-ssh-keys.enable = false;

  services.tailscale = {
    useRoutingFeatures = "server";
    extraSetFlags = [ "--advertise-exit-node" ];
  };

  services.k3s = {
    enable = true;
    autoDeployCharts.argo-cd = {
      name = "argo-cd";
      repo = "oci://ghcr.io/argoproj/argo-helm/argo-cd";
      version = "10.9.6";
      hash = "sha256-btqQvdGN5ThRHJuayhynunocpbkZ9ZhxTQ6RzXFV0Rk=";
      targetNamespace = "argo-cd";
      createNamespace = true;
    };
    manifests.argo-cd-root.content = {
      apiVersion = "argoproj.io/v1alpha1";
      kind = "Application";
      metadata = {
        name = "root";
        namespace = "argo-cd";
      };
      spec = {
        project = "default";
        source = {
          repoURL = "https://github.com/kazu728/manifests.git";
          targetRevision = "main";
          path = "clusters/main";
        };
        destination = {
          server = "https://kubernetes.default.svc";
          namespace = "argo-cd";
        };
        syncPolicy.automated = {
          prune = true;
          selfHeal = true;
        };
      };
    };
  };

  networking.firewall.trustedInterfaces = [ "cni0" ];
}
