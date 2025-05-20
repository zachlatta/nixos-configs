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
  
  # Define a standard cursor theme name instead of the custom one
  hyprland-cursor-name = "Adwaita";
  hyprland-cursor-size = 24; # Example size, adjust as needed
  
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

  # Enable Tailscale
  services.tailscale.enable = true;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
  networking.firewall.checkReversePath = "loose";

  # 1️⃣  **Drop GNOME**
  services.xserver.enable = false;   # turn off X11 desktop stack
  services.xserver.desktopManager.gnome.enable = lib.mkForce false;
  services.xserver.displayManager.gdm.enable = lib.mkForce false;

  # 2️⃣  **Enable Hyprland system-wide**
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;         # X11 apps
  };

  # Needed for xdg-desktop-portal-hyprland
  xdg.portal = {
    enable = true;
    wlr.enable = true; # Module for wlroots-based compositors
    # Override so xdg-desktop-portal-hyprland is used
    extraPortals = [ pkgs.xdg-desktop-portal-gtk config.programs.hyprland.portalPackage ];
    config.common.default = "*"; # Use Hyprland portal by default
  };

  # 3️⃣  **Pick a Wayland-native login manager**
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland"; # Use pkgs.hyprland for greetd command
        user = "zrl";
      };
    };
  };

  # Add NVIDIA video driver (for Xwayland and potentially TTY)
  services.xserver.videoDrivers = [ "nvidia" ];

  # Configure keymap in X11 (for Xwayland and potentially TTY)
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
    # Low-latency for gaming/audio work (optional)
    # lowLatency.enable = true;
  };

  services.openssh.enable = true;

  # User settings
  users.users.zrl = {
    isNormalUser = true;
    description = "Zach Latta";
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "i2c" "docker" "video" "audio" ]; # Added video and audio
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDpKJ1d7joFUV8aWOcR3wEwJOCiMyqmnGraiLJGVD/nD zrl@shinx"
    ];
    packages = with pkgs; [
      # Add user-specific packages here
      firefox
      kitty
      wofi
      mako
      wl-clipboard
      slurp
      grim
      brightnessctl
      playerctl
      wlogout
      dolphin
      hyprpaper
      
      # Fonts
      noto-fonts
      noto-fonts-cjk-sans  # Updated name
      noto-fonts-emoji
      
      # Standard cursor theme instead of custom
      adwaita-icon-theme  # Corrected to direct package
    ];
  };

  # Temporarily disable Home Manager to isolate the issue
  # home-manager = {
  #  useGlobalPkgs = true;
  #  useUserPackages = true;
  #  extraSpecialArgs = { inherit inputs; };
  #  users.zrl = import ./home/default.nix;
  # };

  # Nix settings
  nix.settings = {
    auto-optimise-store = true;
    trusted-users = [ "root" "zrl" ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Clean /tmp on boot
  boot.tmp.cleanOnBoot = true;

  # SSD optimizations
  boot.kernel.sysctl = { "vm-swappiness" = 1; };
  services.fstrim.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # 4️⃣  **GPU / NVIDIA tweaks for wlroots compositors**
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";       # fixes disappearing cursor on NVIDIA
    # GBM_BACKENDS_PATH = "${pkgs.mesa.drivers}/lib/gbm"; # Mesa GBM, not needed for NVIDIA proprietary
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";

    # Hyprland specific env vars
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";

    # QT platform settings
    QT_QPA_PLATFORM = "wayland;xcb"; # Wayland with XCB fallback
    QT_QPA_PLATFORMTHEME = "gtk3"; # Or "qt5ct" or "qt6ct" if you configure them
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    # Cursor
    HYPRCURSOR_THEME = hyprland-cursor-name;
    HYPRCURSOR_SIZE = toString hyprland-cursor-size;
  };
  
  # Ensure cursor theme is available system-wide
  environment.pathsToLink = [ "/share/icons" ];

  environment.etc."profile.d/z-cargo-path.sh" = {
    text = ''
      # Prepend $HOME/.cargo/bin to PATH if it exists and is not already in PATH
      if [ -d "$HOME/.cargo/bin" ]; then
        case ":$PATH:" in
          *":$HOME/.cargo/bin:"*) :;; # Already in PATH
          *) export PATH="$HOME/.cargo/bin:$PATH" ;;
        esac
      fi
    '';
    mode = "0644";
  };

  # 5️⃣  **System packages**
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    # Development tools from unstable
    unstable.rustc
    unstable.cargo
    unstable.gcc
    unstable.gnumake
    unstable.pkg-config

    vscode
    unstable.code-cursor
    google-chrome      # Keep the original for compatibility
    chrome-hidpi       # Our HiDPI wrapper
    
    # NVIDIA related packages
    nvidia-vaapi-driver   # HW video decode
    vulkan-tools          # `vulkaninfo`, `vkcube`
    glxinfo               # sanity check OpenGL
    
    # Fonts
    noto-fonts
    noto-fonts-cjk-sans    # Updated package name
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) # Example Nerd Font
    font-awesome # For icons in bars/launchers
    
    # Standard cursor theme instead of custom
    adwaita-icon-theme    # Corrected to direct package
  ];

  system.stateVersion = "24.11"; # Did you read the comment?

  # NVIDIA specific configuration
  hardware.nvidia = {
    modesetting.enable = true;          # lets Xorg & Wayland share the GPU
    powerManagement.enable = false;      # Often better to disable for desktops, or set to 'fine-grained'
    powerManagement.finegrained = false; # if powerManagement.enable = true
    nvidiaSettings = true;              # installs the nvidia-settings GUI
    open = false;                       # Prefer proprietary drivers
    package = config.boot.kernelPackages.nvidiaPackages.stable; # Or .beta, .production
  };

  # Enable DRM kernel modesetting (essential for NVIDIA on Wayland)
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
  
  # Create a default Hyprland config for the user
  environment.etc."xdg/hypr/hyprland.conf".text = ''
    # See https://wiki.hyprland.org/Configuring/Monitors/
    monitor=eDP-1,preferred,auto,1.5

    # Set cursor
    exec-once = hyprctl setcursor ${hyprland-cursor-name} ${toString hyprland-cursor-size}
    
    # Autostart
    exec-once = hyprpaper
    exec-once = mako
    exec-once = nm-applet --indicator

    # General settings
    general {
      gaps_in = 5
      gaps_out = 10
      border_size = 2
      col.active_border = rgba(ca9ee6ee) rgba(f2d5cfea) 45deg
      col.inactive_border = rgba(414559aa)
      layout = dwindle
    }

    # Decoration
    decoration {
      rounding = 10
      blur {
        enabled = true
        size = 3
        passes = 2
      }
      drop_shadow = true
      shadow_range = 4
      shadow_render_power = 3
      col.shadow = rgba(1a1a1aee)
    }

    # Input configuration
    input {
      kb_layout = us
      follow_mouse = 1
      touchpad {
        natural_scroll = true
      }
      sensitivity = 0
      accel_profile = flat
    }

    # Basic keybindings
    bind = SUPER, RETURN, exec, kitty
    bind = SUPER, D, exec, wofi --show drun
    bind = SUPER, Q, killactive
    bind = SUPER, M, exit
    bind = SUPER, F, fullscreen
    bind = SUPER, SPACE, togglefloating

    # Move focus
    bind = SUPER, left, movefocus, l
    bind = SUPER, right, movefocus, r
    bind = SUPER, up, movefocus, u
    bind = SUPER, down, movefocus, d

    # Workspaces
    bind = SUPER, 1, workspace, 1
    bind = SUPER, 2, workspace, 2
    bind = SUPER, 3, workspace, 3
    bind = SUPER, 4, workspace, 4
    bind = SUPER, 5, workspace, 5

    # Move windows to workspaces
    bind = SUPER SHIFT, 1, movetoworkspace, 1
    bind = SUPER SHIFT, 2, movetoworkspace, 2
    bind = SUPER SHIFT, 3, movetoworkspace, 3
    bind = SUPER SHIFT, 4, movetoworkspace, 4
    bind = SUPER SHIFT, 5, movetoworkspace, 5

    # Plugin config (hyprbars)
    plugin {
      hyprbars {
        bar_height = 24
        col.text = rgb(e5e5e5)
      }
    }
    
    # Hyprbars buttons
    hyprbars-button = rgb(235, 137, 137), 18, , hyprctl dispatch killactive
    hyprbars-button = rgb(138, 173, 244), 18, , hyprctl dispatch fullscreen 1
    hyprbars-button = rgb(245, 224, 179), 18, , hyprctl dispatch togglefloating
  '';
}
