{ pkgs, ... }:

{
  vim-esearch = pkgs.vimUtils.buildVimPlugin {
    name = "vim-esearch";
    src = pkgs.fetchFromGitHub {
      owner = "eugen0329";
      repo = "vim-esearch";
      rev = "02db26e593b80c2908b25ae558c2f0db7f135051";
      sha256 = "1gmvj7wansg7vjj3fni0pjk7c4d1w8smgbj2qxwcwqsdj5z5j5cv";
    };

    # we need this line to prevent it from running `make`, which will fail
    buildPhase = "echo 'skip the build phase'";
  };
}
