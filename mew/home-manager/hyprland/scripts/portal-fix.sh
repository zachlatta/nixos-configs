#!/usr/bin/env bash
# Fix for xdg-desktop-portal-hyprland (if needed)
sleep 1
killall -e xdg-desktop-portal-hyprland
killall -e xdg-desktop-portal-wlr
killall xdg-desktop-portal
sleep 1
# Adjust path if needed - on NixOS this path will likely be in the nix store
/nix/store/$(ls -la /run/current-system/sw/bin/xdg-desktop-portal-hyprland | awk '{print $11}' | cut -d "/" -f 4)/libexec/xdg-desktop-portal-hyprland &
sleep 1
systemctl --user restart xdg-desktop-portal.service 