# Passthrough of audio from Windows VM -> Linux environment
#
# Requires Scream to be instaled and running in Windows VM.
#
# TODO: Audio has seemed to stop working. I am not sure why. Need to
# investigate and fix. I can see the packets being sent with tcpdump, but the
# Scream client cannot seem to see and process them.
{ pkgs, ... }:
let interface = "br0";
in {
  systemd.user.services.scream = {
    enable = true;
    description = "Scream";

    serviceConfig = {
      ExecStart = "${pkgs.scream}/bin/scream -i ${interface} -o alsa";
      Restart = "always";
    };

    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];

    after = [ "pipewire.service" ];
  };

  networking.firewall.interfaces."${interface}".allowedUDPPorts = [ 4010 ];
}
