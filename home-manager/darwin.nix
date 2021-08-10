# modules to import on darwin platform (ex. we don't want mako because that's
# linux only)
{ ... }:
{
  imports = [
    ./alacritty.nix
    ./git.nix
    ./vim.nix
  ];
}
