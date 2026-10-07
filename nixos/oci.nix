{ modulesPath, pkgs, ... }:

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

  services.opentelemetry-collector = {
    enable = true;
    package = pkgs.opentelemetry-collector-contrib;
    settings = {
      extensions.file_storage.directory = "/var/lib/opentelemetry-collector";
      receivers.journald.storage = "file_storage";
      processors = {
        resource.attributes = [
          {
            key = "service.name";
            value = "systemd-journal";
            action = "insert";
          }
        ];
        batch = { };
      };
      exporters.otlp_http.endpoint = "http://10.43.0.100:4318";
      service = {
        extensions = [ "file_storage" ];
        pipelines.logs = {
          receivers = [ "journald" ];
          processors = [
            "resource"
            "batch"
          ];
          exporters = [ "otlp_http" ];
        };
      };
    };
  };
}
