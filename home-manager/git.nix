{ ... }: {
  programs.git = {
    enable = true;

    userName = "Zach Latta";
    userEmail = "zach@zachlatta.com";

    extraConfig = {
      init = { defaultBranch = "main"; };

      pull = { rebase = true; };

      safe = { directory = "*"; };
    };

    ignores = [
      # Vim files
      ''
        # Swap
        [._]*.s[a-v][a-z]
        !*.svg  # comment out if you don't need vector files
        [._]*.sw[a-p]
        [._]s[a-rt-v][a-z]
        [._]ss[a-gi-z]
        [._]sw[a-p]

        # Session
        Session.vim
        Sessionx.vim

        # Temporary
        .netrwhist
        *~
        # Auto-generated tag files
        tags
        # Persistent undo
        [._]*.un~
      ''

      # direnv cache directories
      ".direnv/"

      # we never want .env committed
      ".env"
    ];
  };
}
