# .dotfiles

Re-doing my dotfiles. Problems with previous set of dotfiles:

- Difficult to edit (not very "hackable")
- Lots of cruft that was no longer used, which made it difficult to see everything that was going on
  - Part of this was the dual-OS support between macOS and Linux
- Annoying to set up on new machines, particularly when it came to theme support (solarized would *always* break on new machines, especially SSHed Linux instances)
  - rcm always felt clunky, symlinks would take forever - especially with the submodule for bash-completion
    - I never used any features of it besides `rcup -v`
- bash never got to the point where it felt great to use

Goals for this new set of dotfiles:

- Low time-to-input and time-to-edit (feels "hackable")
- Very, very quick to get a great vim (maybe neovim?) environment
  - <2m on a brand new machine
  - Should not leave me reading for VS Code when doing more complicated dev work
- A shell that I love using, bash or otherwise

---

Dependencies:

- Neovim
- Zsh
- Tmux
- Rust
- GNU sed installed (assuming machine is on macOS)
- GNU coreutils installed (again, assuming machine is on macOS)
- Starship (the prompt) installed
- Alacritty (terminal emulator)
- Fira Code font installed
- nodejs + npm + yarn installed
- _there are lots more now for Linux, I forget all..._

---

To-Do for `psyduck`:

- [ ] Make audio no longer tinny
- [ ] Properly scale dmenu for HiDPI (or find alternative)
- [ ] Fix blurry cursor in Xwayland apps
- [ ] Get LTE chip working
  - I attempted to do this by converting the PCI device to a USB device, but never got Modem Manager working. Need to figure this out.
- [x] Make audio buttons work
- [x] Make brightness buttons work
- [ ] Show battery life in desktop environment
- [ ] Fix Secure Boot

---

Ideas:

- Series of compiled executables for quick utilities, written in a fun language - maybe Rust? Better than writing bash.
  - Ideas for utilities:
    - [x] Check ~/dev/inbox for existence of files and notify user whenever they open a new shell, much like new mail in CLI mailboxes
      - TODO: Sort by most recently modified
      - Idea: Preview contents of files by showing 1st 15 words or something like that
- Consider looking into [GNU Stow](https://www.gnu.org/software/stow/manual/stow.html) to manage symlinks
- Make neomutt colors nicer
- Make neomutt _way_ faster
- Break out dotfiles for different systems (ex. psyduck configs vary from zapdos)
- Good Markdown workflow for publishing to Wordpress
- Good timelapse CLI workflow

---

Bookmarks / references:

- https://git.mehalter.com/mehalter/dotfiles
