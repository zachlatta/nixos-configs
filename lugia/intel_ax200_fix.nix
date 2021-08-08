# this disables power saving mode on the intel ax200 wifi card, which makes it
# way more reliable and less finnicky
#
# see https://gist.github.com/zachlatta/67cf85aa287e50be20b8c338713f3184 for more
{ config, pkgs, ... }:

{
  boot.extraModprobeConfig = "
options iwlwifi power_save=0
options iwlmvm power_scheme=1
  ";
}
