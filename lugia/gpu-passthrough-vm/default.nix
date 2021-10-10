# Configuration to passthrough my Nvidia GPU to a Windows VM.
#
# Current problems:
#
# - Need to restart scream in user environment for sound to start coming
#   through (maybe it's starting after the wrong service?)
#
# - Nvidia GPU fan runs at 100% when passed through
#
# - Potential Looking Glass shared RAM permissions issue - should double check this

{ ... }: {
  imports = [ ./looking-glass ./scream ];

  boot.initrd.availableKernelModules = [ "amdgpu" "vfio-pci" ];
  boot.initrd.preDeviceCommands = ''
    DEVS="0000:04:00.0 0000:04:00.1"
    for DEV in $DEVS; do
    echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
    done
    modprobe -i vfio-pci
  '';

  boot.kernelParams = [ "amd_iommu=on" "pcie_aspm=off" ];

  virtualisation.libvirtd = {
    enable = true;
    qemuOvmf = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };
}
