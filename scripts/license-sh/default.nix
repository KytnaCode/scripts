{
  pkgs,
  lib,
  ...
}: let
  name = "license.sh";
in
  pkgs.runCommand name {
    text = builtins.readFile ./license.sh;
  } ''
    target=$out${lib.escapeShellArg "/bin/${name}"}
    mkdir -p "$(dirname "$target")"

    echo -n "$text" > "$target"

    chmod +x "$target"

    cp ${./licenses.json} $out/bin/licenses.json

    eval "$checkPhase"
  ''
