# `nixos-configs` / dotfiles

As I try out NixOS as my main OS, I'm having my NixOS configs take over my dotfiles. Format of repository inspired by <https://github.com/Xe/nixos-configs>.

Branches in this repository are timestamped "logs" of when I last reset my dotfiles. For example, if you go to the branch `2020-01-09`, you can see my dotfiles shortly before I reset them.

## `hosts/` breakdown

### shinx

MacBook Air 15". Not using Nix for this, just normal dotfiles.

### lugia

Desktop machine at home. Like Xe's sachi, this is an apex predator. Ryzen 9 3950x with 32 GB of RAM, a Radeon RX 5700 GPU, and a RTX 3080 Ti.

#### electrode

This is a VM running on lugia that uses VFIO passthrough for native graphics performance. The 3080 Ti is passed through to the Windows VM. It also runs on a separate NVMe drive, which allows dual booting straight into Windows in addition to running Windows in a VM.

### kadabra-dev

MacBook Air M2 running a NixOS VM for development.

### slowking

This is a Synology NAS running at home, with services available through Tailscale. I tried using NixOS to manage it, but never got a setup that felt nice. Instead, I'm just using Docker Compose for now (don't love it though - it keeps breaking).
