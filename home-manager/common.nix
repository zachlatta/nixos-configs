{ pkgs, ... }: {
  home.packages = with pkgs; [
    killall
    file

    wget
    htop
    glances
    tree
    ripgrep

    youtube-dl

    go
    rustc
    cargo
    clang # includes cc linker for rust
  ];
}
