{ ... }: {
  imports = [
    ./alacritty.nix
    #./fish.nix
    ./bash.nix
    ./git.nix
    ./mako.nix
    ./tmux.nix
    ./vim.nix
    ./vscode-server.nix
  ];
}
