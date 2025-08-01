# Scripts

My personal collection of scripts.

## Portability

All scripts are intended only for nix-based systems running linux x86_64, all scripts make use of nix shell shebangs
and may use linux only stuff, some of them may work well on other platforms, but I don't support them, packages are
only available for x86_64-linux, if you feel lucky you can force nix to use them on other platforms with:

```bash
nix run .#packages.x86_64-linux.<package>
```

## license.sh

```bash
license.sh
```

`license.sh` let you choose from a list of licenses (fetched from
[GitHub API](https://docs.github.com/en/rest/licenses/licenses?apiVersion=2022-11-28#get-a-license)) and writes the
selected one to `LICENSE.txt`.

MIT license require the name of the copyright holder (you) and the current year, if you choose it you will be prompted
for a name, and the current year will be used.
