# Set up commonly used URLs as hostnames that nginx redirects to full URLs.
{ ... }:
let
  links = [
    [ "pokedex" "https://drive.google.com/drive/folders/0ACzwx42JIgErUk9PVA" ]
    [ "notes" "https://app.standardnotes.org/" ]
    [ "slack" "https://hackclub.slack.com/" ]
  ];
in
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
  services.nginx.virtualHosts = builtins.listToAttrs (map (link:
    {
      name = "${builtins.elemAt link 0}";
      value = {
        locations = {
          "/" = {
            return = "302 ${builtins.elemAt link 1}";
          };
        };
      };
    }
  ) links);


  # this create an entry like `127.0.0.1 pokedex` for each item in links
  networking.extraHosts = builtins.concatStringsSep "\n" (map (link: "127.0.0.1 ${builtins.elemAt link 0}") links);
}
