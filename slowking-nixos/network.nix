{
  network.description =
    "slowking-nixos deployment at home with a public relay server";

  "slowking-nixos" = { config, pkgs, lib, ... }: {
    deployment.targetUser = "root";
    deployment.targetHost = "slowking-nixos";

    imports = [ ./conf/configuration.nix ];
  };

  # hosted on vultr
  "relay" = { config, pkgs, lib, ... }: {
    deployment.targetUser = "root";
    deployment.targetHost = "relay";

    imports = [ ./conf-relay/configuration.nix ];
  };
}
