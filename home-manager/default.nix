{ ... }: {
  imports = [
    ./common.nix

    #./fish.nix
    ./vscode-server.nix
    ./alacritty.nix
    ./bash.nix
    ./git.nix
    ./mako.nix
    ./mpv.nix
    ./tmux.nix
    ./vim.nix
  ];
}
