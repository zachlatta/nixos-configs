{ ... }: {
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    "zachlatta.com" = {
      image = "zachlatta/zachlatta.com:latest";
      ports = [ "1337:80" ];
      volumes = [ "/mnt/pokedex/apps/zachlatta.com/db:/zachlatta.com/db" ];
    };
  };
}