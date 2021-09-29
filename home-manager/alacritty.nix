{ ... }: {
  programs.alacritty = {
    enable = true;

    settings = {
      # this is needed to allow interactivity when SSHing into other
      # machines, since they will not recognize Alacritty as a terminal
      env.TERM = "xterm-256color";

      window = {
        dimensions = {
          lines = 24;
          columns = 80;
        };

        padding = {
          x = 6;
          y = 3;
        };

        dynamic_padding = true;
      };

      key_bindings = [
        {
          key = "N";
          mods = "Control";
          action = "SpawnNewInstance";
        }
        {
          key = "Q";
          mods = "Control";
          action = "Quit";
        }
      ];

      font = { size = 10; };

      # Base16 Tomorrow Night 256 - alacritty color config
      # Chris Kempson (http://chriskempson.com)
      colors = {
        # Default colors
        primary = {
          background = "0x1d1f21";
          foreground = "0xc5c8c6";
        };

        # Colors the cursor will use if `custom_cursor_colors` is true
        cursor = {
          text = "0x1d1f21";
          cursor = "0xc5c8c6";
        };

        # Normal colors
        normal = {
          black = "0x1d1f21";
          red = "0xcc6666";
          green = "0xb5bd68";
          yellow = "0xf0c674";
          blue = "0x81a2be";
          magenta = "0xb294bb";
          cyan = "0x8abeb7";
          white = "0xc5c8c6";
        };

        # Bright colors
        bright = {
          black = "0x969896";
          red = "0xcc6666";
          green = "0xb5bd68";
          yellow = "0xf0c674";
          blue = "0x81a2be";
          magenta = "0xb294bb";
          cyan = "0x8abeb7";
          white = "0xffffff";
        };

        indexed_colors = [
          {
            index = 16;
            color = "0xde935f";
          }
          {
            index = 17;
            color = "0xa3685a";
          }
          {
            index = 18;
            color = "0x282a2e";
          }
          {
            index = 19;
            color = "0x373b41";
          }
          {
            index = 20;
            color = "0xb4b7b4";
          }
          {
            index = 21;
            color = "0xe0e0e0";
          }
        ];
      };
    };
  };
}
