# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, inputs, lib, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
  
  # Create a script that wraps Chrome with HiDPI flags
  chrome-hidpi = pkgs.writeShellScriptBin "chrome-hidpi" ''
    exec ${pkgs.google-chrome}/bin/google-chrome-stable \
      --enable-features=UseOzonePlatform \
      --ozone-platform-hint=wayland \
      --force-device-scale-factor=1.5 \
      "$@"
  '';
  
  # NEW ────────────────────────────────────────────────────────────────────
  hyprDrv = unstable.hyprland;      # freshest Hyprland build
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-2cefa249-799d-4838-8b3b-59a12fd82445".device = "/dev/disk/by-uuid/2cefa249-799d-4838-8b3b-59a12fd82445";
  networking.hostName = "mew";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # 1️⃣  **Drop GNOME**
  services.xserver.enable = false;   # turn off X11 desktop stack
  services.xserver.desktopManager.gnome.enable = lib.mkForce false;
  services.xserver.displayManager.gdm.enable = lib.mkForce false;

  # 2️⃣  **Enable Hyprland system-wide**
  programs.hyprland = {
    enable = true;
    package = hyprDrv;      # ← pulls the unstable build
    xwayland.enable = true;         # X11 apps
  };

  # 3️⃣  **Pick a Wayland-native login manager**
  services.displayManager.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "Hyprland";
        user = "zrl";
      };
    };
  };

  # Add NVIDIA video driver
  services.xserver.videoDrivers = [ "nvidia" ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.zrl = {
    isNormalUser = true;
    description = "Zach Latta";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # 4️⃣  **GPU / NVIDIA tweaks for wlroots compositors**
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";       # fixes disappearing cursor on NVIDIA
    GBM_BACKENDS_PATH = "${pkgs.mesa_drivers}/lib/gbm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    # keep your HiDPI overrides
    GDK_SCALE = "1";
    GDK_DPI_SCALE = "1.5";
    QT_SCALE_FACTOR = "1.5";
    QT_AUTO_SCREEN_SCALE_FACTOR = "0";
    QT_SCREEN_SCALE_FACTORS = "";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    ELECTRON_ENABLE_WAYLAND = "1";
    ELECTRON_USE_OZONE = "1";
  };

  # 5️⃣  **System packages**
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    code2prompt

    vscode
    unstable.code-cursor
    google-chrome      # Keep the original for compatibility
    chrome-hidpi       # Our HiDPI wrapper
    
    # NVIDIA related packages
    nvidia-vaapi-driver   # HW video decode
    vulkan-tools          # `vulkaninfo`, `vkcube`
    glxinfo               # sanity check OpenGL
    wl-clipboard          # Wayland clipboard utilities
    xclip                 # X11 clipboard tool

    # Hyprland packages
    hyprDrv                # compositor & binaries
    unstable.hyprpicker    # color picker
    unstable.waybar        # status bar
    unstable.swww          # animated wallpapers
    wl-clipboard           # wl-copy / wl-paste
    unstable.grim unstable.slurp  # screenshots
    unstable.wofi          # application launcher
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # NVIDIA specific configuration
  hardware.nvidia = {
    modesetting.enable = true;          # lets Xorg & Wayland share the GPU
    powerManagement.enable = true;      # automatic clock & fan control
    nvidiaSettings = true;              # installs the nvidia-settings GUI
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable DRM kernel modesetting
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  # Create a desktop file for our HiDPI Chrome wrapper
  environment.etc."xdg/applications/chrome-hidpi.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Name=Google Chrome (HiDPI)
    Exec=chrome-hidpi %U
    Terminal=false
    Icon=google-chrome
    Type=Application
    Categories=Network;WebBrowser;
    MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/pdf;x-scheme-handler/http;x-scheme-handler/https;
    StartupWMClass=Google-chrome-stable
  '';
}
