# Passthrough of audio from Windows VM -> Linux environment
#
# Requires Scream to be instaled and running in Windows VM.
{ pkgs, ... }: {
  systemd.user.services.scream = {
    enable = true;
    description = "Scream";
    serviceConfig = {
      ExecStart = "${pkgs.scream}/bin/scream -i virbr0 -o alsa";
      Restart = "always";
    };
    wantedBy = [ "default.target" ];
    after = [ "pipewire.service" ];
    wants = [ "pipewire.service" ];
  };

  networking.firewall.interfaces.virbr0.allowedUDPPorts = [ 4010 ];
}
