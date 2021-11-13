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
    # PCI devices to not load and use vfio-pci insted for
    #     gpu          gpu audio    nvme ssd     usb controller to pass through
    DEVS="0000:0d:00.0 0000:0d:00.1 0000:01:00.0 0000:0f:00.3"

    for DEV in $DEVS; do
      echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
    done

    modprobe -i vfio-pci

    # from https://forums.unraid.net/topic/83680-solved-nvidia-gpu-pass-through-via-rom-edit-method/?do=findComment&comment=775838
    #
    # fixes: "vfio-pci 0000:0d:00.0: BAR 1: can't reserve [mem
    # 0xb0000000-0xbfffffff 64bit pref]" error preventing video from being
    # loaded in vm
    echo 0 > /sys/class/vtconsole/vtcon0/bind
    echo 0 > /sys/class/vtconsole/vtcon1/bind
    echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind
  '';

  boot.kernelParams = [ "amd_iommu=on" "pcie_aspm=off" ];

  virtualisation.libvirtd = {
    enable = true;
    qemuOvmf = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };
}
