# Set up commonly used URLs as hostnames that nginx redirects to full URLs.
{ lib, pkgs, ... }:
with builtins;
let
  links = [
    [ "pokedex" "https://drive.google.com/drive/folders/0ACzwx42JIgErUk9PVA" ]
    [ "notes" "https://app.standardnotes.org/" ]
    [ "slack" "https://hackclub.slack.com/" ]
    [ "hm-config" "https://rycee.gitlab.io/home-manager/options.html" ]
    [ "nixos-config" "https://search.nixos.org/options" ]
    [ "nixos-pkgs" "https://search.nixos.org/packages" ]
  ];

  shortlinksIndexName = "shortlinks";

  shortlinksIndex = pkgs.writeTextDir "index.html" ''
    <!DOCTYPE html>
    <html>
      <head>
        <style>
          /* keep links original color after clicking */
          a:visited {
            color: blue;
          }
        </style>
      </head>
      <body>
        <p>shortlinks</p>

        <ul>
          ${
            concatStringsSep "\n" (map (link:
              ''
                <li><a href="http://${elemAt link 0}/">${elemAt link 0}</a> - ${
                  elemAt link 1
                }</li>'') links)
          }
        </ul>
      </body>
    </html>
        '';
in {
  services.nginx.enable = true;

  # this converts links to something that looks like:
  #
  # services.nginx.virtualHosts = {
  #   "pokedex" = {
  #     locations = {
  #       "/" = {
  #         return = "302 http://example.com";
  #       };
  #     };
  #   };
  #   ...and so on, for each element
  # };
  services.nginx.virtualHosts = listToAttrs (map (link: {
    name = "${elemAt link 0}";
    value = { locations = { "/" = { return = "302 ${elemAt link 1}"; }; }; };
  }) links) // {
    "${shortlinksIndexName}" = { root = "${shortlinksIndex}"; };
  };

  # this creates an entry like `127.0.0.1 pokedex` for each item in links, and it also creates one for the shortlinks index
  networking.extraHosts = concatStringsSep "\n"
    (map (link: "127.0.0.1 ${elemAt link 0}")
      (links ++ [ [ shortlinksIndexName ] ]));
}
