{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  hyprcursor, # hyprcursor utility
  variant ? "modern",
  baseColor ? "000000",      # Default to black (without #)
  outlineColor ? "FFFFFF",   # Default to white (without #)
  watchBackgroundColor ? "000000", # Default to black (without #)
  colorName ? "classic",
}: let
  pyPkgs = python3.pkgs;
  capitalize = str: let
    capital_letter = builtins.substring 0 1 str;
    non_capital = lib.removePrefix capital_letter str;
  in
    lib.toUpper capital_letter + non_capital;

  themeName = "Bibata-${capitalize variant}-${capitalize colorName}-Hyprcursor";
in
  assert builtins.elem variant ["modern" "modern-right" "original" "original-right"];
    stdenvNoCC.mkDerivation (final: {
      pname = "bibata-hyprcursor";
      version = "v2.0.7"; # Match the example or update if necessary

      src = fetchFromGitHub {
        owner = "ful1e5";
        repo = "Bibata_Cursor";
        rev = final.version;
        hash = "sha256-kIKidw1vditpuxO1gVuZeUPdWBzkiksO/q2R/+DUdEc="; # From example
      };

      nativeBuildInputs = [
        python3
        pyPkgs.tomli
        pyPkgs.tomli-w
        hyprcursor
      ];

      phases = ["unpackPhase" "configurePhase" "buildPhase" "installPhase"];

      unpackPhase = ''
        runHook preUnpack

        cp $src/configs/${
          if lib.hasSuffix "right" variant
          then "right"
          else "normal"
        }/x.build.toml config.toml

        mkdir cursors
        # Correctly copy svgs from the specified variant directory
        for cursor_path in $src/svg/${variant}/*; do
          cursor_name=$(basename "$cursor_path")
          if [ -d "$cursor_path" ]; then # If it's a directory (animated cursor)
            # Skip the "wait" directory if it doesn't contain valid SVG files
            if [ "$cursor_name" = "wait" ]; then
              # First check if the directory has SVG files before copying
              if ls "$cursor_path"/*.svg >/dev/null 2>&1; then
                cp -r "$cursor_path" cursors/
              else
                echo "Skipping directory $cursor_name as it doesn't contain valid SVG files"
              fi
            else
              cp -r "$cursor_path" cursors/
            fi
          elif [ -f "$cursor_path" ]; then # If it's a file (static cursor)
            # Check if it's a symlink first
            if [ -L "$cursor_path" ]; then
               # If symlink, copy the target. This logic might need refinement
               # based on how Bibata structures its symlinks vs actual files.
               # For simplicity, let's assume direct files or dirs are what we want.
               # A more robust way might be to copy $src/svg/${variant}/$(readlink $cursor_path_name_only)
               # but readlink on a full path might be tricky.
               # This should be okay if symlinks point within the variant dir.
               cp -L "$cursor_path" cursors/ # -L dereferences symlinks
            else
               cp "$cursor_path" cursors/
            fi
          fi
        done
        
        # Let's make sure we have a valid directory structure
        echo "Contents of cursors directory:"
        ls -la cursors/
        
        # The original example's loop was a bit complex for general cases.
        # The goal is to get all .svg files or directories of .svg files from $src/svg/${variant}/
        # into the local `cursors` directory.

        chmod -R u+w .

        runHook postUnpack
      '';

      configurePhase = ''
        runHook preConfigure

        cat << EOF > manifest.hl
        name = ${themeName}
        description = The Bibata Cursor theme packaged for hyprcursor.
        version = ${final.version}
        cursors_directory = cursors
        EOF

        # Ensure colors are hex without '#' for sed
        s_baseColor="${lib.removePrefix "#" baseColor}"
        s_outlineColor="${lib.removePrefix "#" outlineColor}"
        s_watchBackgroundColor="${lib.removePrefix "#" watchBackgroundColor}"

        find cursors -type f -name '*.svg' | xargs sed -i \
          -e "s/#00FF00/#$s_baseColor/g" \
          -e "s/#0000FF/#$s_outlineColor/g" \
          -e "s/#FF0000/#$s_watchBackgroundColor/g"

        # Modify the configure.py script to handle missing directories
        python ${./configure.py} config.toml cursors

        runHook postConfigure
      '';

      buildPhase = ''
        runHook preBuild
        hyprcursor-util --create . --output .
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/icons
        cp -r theme_${themeName} $out/share/icons/${themeName}

        runHook postInstall
      '';

      meta = with lib; {
        description = "Bibata cursor theme, packaged for Hyprland's hyprcursor";
        homepage = "https://github.com/ful1e5/Bibata_Cursor";
        license = licenses.gpl3Plus; # Check Bibata's license
        platforms = platforms.linux;
      };
    }) 