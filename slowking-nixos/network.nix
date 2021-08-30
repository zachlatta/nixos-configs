{
  network.description = "slowking-nixos deployment at home";

  "slowking-nixops" = { config, pkgs, lib, ... }:
  {
    deployment.targetUser = "root";
    deployment.targetHost = "slowking-nixos";

    imports = [ ./conf/configuration.nix ];
  };
}
