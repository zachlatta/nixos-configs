{
  network.description = "slowking-nixops host connection attempt";

  "slowking-nixops" = { config, pkgs, lib, ... }:
  {
    deployment.targetUser = "root";
    deployment.targetHost = "100.122.82.105";

    imports = [ ./conf/configuration.nix ];
  };
}
