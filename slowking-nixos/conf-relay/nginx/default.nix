{ ... }: {
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."zachlatta.com" = {
      default = true;

      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://slowking:1337";
        proxyWebsockets = true;
      };
    };

    virtualHosts."www.zachlatta.com" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = { return = "302 https://zachlatta.com/"; };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Required for automated SSL certificate getting and renewal
  security.acme = {
    email = "zach@zachlatta.com";
    acceptTerms = true;
  };
}
