# Passthrough of audio from Windows VM -> Linux environment
#
# Requires Scream to be instaled and running in Windows VM.
{ pkgs, ... }: {
  systemd.user.services.scream = {
    enable = true;
    description = "Scream";
    serviceConfig = {
      ExecStart = "${pkgs.scream}/bin/scream -i virbr0";
      Restart = "always";
    };
    wantedBy = [ "default.target" ];
    after = [ "pipewire-pulse.service" ];
    wants = [ "pipewire-pulse.service" ];
  };

  networking.firewall.trustedInterfaces = [
    "virbr0"
  ]; # TODO consider changing to just trusting the UDP traffic for scream on this interface
}
