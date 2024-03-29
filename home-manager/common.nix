{ pkgs, ... }: {
  home.packages = with pkgs; [
    killall
    file

    wget
    htop
    glances
    tree
    ripgrep
    bat

    youtube-dl

    go
    rustup
    clang # includes cc linker needed for rust
    rust-analyzer
  ];
}
