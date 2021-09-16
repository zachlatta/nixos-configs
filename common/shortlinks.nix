# Set up commonly used URLs as hostnames that nginx redirects to full URLs.
{ ... }:
let
  links = [
    [ "pokedex" "https://drive.google.com/drive/folders/0ACzwx42JIgErUk9PVA" ]
    [ "notes" "https://app.standardnotes.org/" ]
    [ "slack" "https://hackclub.slack.com/" ]
  ];
in
with builtins;
{
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
  services.nginx.virtualHosts = listToAttrs (map (link:
    {
      name = "${elemAt link 0}";
      value = {
        locations = {
          "/" = {
            return = "302 ${elemAt link 1}";
          };
        };
      };
    }
  ) links);


  # this create an entry like `127.0.0.1 pokedex` for each item in links
  networking.extraHosts = concatStringsSep "\n" (map (link: "127.0.0.1 ${elemAt link 0}") links);
}
