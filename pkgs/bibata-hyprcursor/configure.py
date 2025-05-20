#!/usr/bin/env python3
# stolen from https://github.com/diniamo/niqspkgs/blob/544c3b2c69fd1b5ab3407e7b35c76060801a8bcf/pkgs/bibata-hyprcursor/default.nix

from sys import argv
import os
from os import path
from pathlib import Path
import tomli
import tomli_w


def fallback_value(config, cursor, field):
    return (config.get(cursor, None) or {}).get(field, None) or (
        config["fallback_settings"].get(field, None)
    )


def filter_none_dict(**kwargs):
    return {k: v for k, v in kwargs.items() if v is not None}


def construct_meta(config, name, sizes):
    meta = filter_none_dict(
        define_size=";".join(sizes),
        define_override=(
            None
            if (overrides := fallback_value(config, name, "x11_symlinks")) is None
            else ";".join(overrides)
        ),
        hotspot_x=fallback_value(config, name, "x_hotspot") / 256,
        hotspot_y=fallback_value(config, name, "y_hotspot") / 256,
    )

    with open(f"{name}/meta.toml", "wb") as file:
        tomli_w.dump({"General": meta}, file)


with open(argv[1], "rb") as file:
    config = tomli.load(file)["cursors"]

os.chdir(argv[2])

for cursor in os.listdir("."):
    if path.isfile(cursor):
        name = Path(cursor).stem

        os.mkdir(name)
        os.rename(cursor, f"{name}/{cursor}")

        construct_meta(config, name, [f"0,{cursor}"])
    else:
        # Check if the directory exists and has content before processing
        if not os.path.isdir(cursor):
            print(f"Warning: {cursor} is not a directory, skipping")
            continue
        
        try:
            # Get the contents of the directory
            cursor_files = os.listdir(cursor)
            if not cursor_files:
                print(f"Warning: {cursor} directory is empty, skipping")
                continue
                
            delay = fallback_value(config, cursor, "x11_delay")
            file_definitions = []
            
            for c in cursor_files:
                if os.path.isfile(os.path.join(cursor, c)):
                    file_definitions.append(f"0,{c},{delay}")
            
            if not file_definitions:
                print(f"Warning: {cursor} contains no valid files, skipping")
                continue
                
            construct_meta(config, cursor, file_definitions)
        except Exception as e:
            print(f"Error processing {cursor}: {e}")
            # Create a dummy file to prevent the build from failing
            if not os.path.exists(f"{cursor}/meta.toml"):
                os.makedirs(cursor, exist_ok=True)
                with open(f"{cursor}/meta.toml", "wb") as file:
                    tomli_w.dump({"General": {"define_size": ""}}, file) 