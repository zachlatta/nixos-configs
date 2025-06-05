# AGENT.md - NixOS Configuration Repository

## Build/Test Commands
- `nixos-rebuild switch --flake .#mew` - Deploy system changes to mew host
- `nix flake check` - Validate flake configuration and all packages
- `nix build .#mew` - Build system configuration without deploying
- `nix run .#logbook` - Run custom packages (logbook is default package)
- `nix flake update` - Update flake.lock with latest input versions

## Code Style Guidelines

### Nix Files
- Use 2-space indentation consistently
- Import modules at top using `{ config, pkgs, lib, inputs, ... }:` pattern
- Use `let...in` blocks for complex expressions and custom packages
- Prefer `with pkgs;` in package lists for cleaner syntax
- Use descriptive variable names (e.g., `hyprland-cursor-name`, `chrome-hidpi`)

### Structure Conventions
- Host configs in `<hostname>/` directories (e.g., `mew/`)
- Custom packages in `pkgs/` with proper `default.nix` files
- Home Manager configs in `<hostname>/home/` subdirectory
- Group related settings into logical modules (programs.nix, services.nix)

### Comments and Documentation
- Include helpful comments for complex derivations and hardware-specific settings
- Document custom wrapper scripts and their purpose
- Use descriptive commit messages following conventional commits format
