# Passthrough of audio from Windows VM -> Linux environment
#
# Requires Scream to be instaled and running in Windows VM.
#
# TODO: Audio has seemed to stop working. I am not sure why. Need to
# investigate and fix. I can see the packets being sent with tcpdump, but the
# Scream client cannot seem to see and process them.
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

  # TODO look into narrowing this permission in the future
  networking.firewall.trustedInterfaces = [ "virbr0" ];
}
