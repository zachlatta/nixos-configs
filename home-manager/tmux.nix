{ pkgs, ... }: {
  programs.tmux = {
    enable = true;

    prefix = "C-a";
    keyMode = "vi";

    extraConfig = ''
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind r source-file ~/.config/tmux/tmux.conf; display-message "reloaded config!"
    '';
  };
}
