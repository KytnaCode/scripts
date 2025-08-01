{pkgs, ...}:
pkgs.writeScriptBin "license.sh" (builtins.readFile ./license.sh)
