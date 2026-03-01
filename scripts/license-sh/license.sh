#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash gum jq
# shellcheck shell=bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

licenses="$(cat "$SCRIPT_DIR"/licenses.json)"

licenses_pairs="$(jq '. as $root | keys[] | [., $root[.].name] | join(" --- ")' <<<"$licenses" | sed -e 's/^"//' -e 's/"$//')"

options="$(printf "%s\nnone" "$licenses_pairs")" # Add none option.

license="$(gum filter <<<"$options" | sed 's/ --- .*//')"

if [[ "$license" == none || -z "$license" ]]; then
  exit 0
fi

license_content="$(jq -r ".[\"$license\"].body" <<<"$licenses")"

echo "$license_content" >LICENSE.txt

# Set name and year.
if [[ $license == "mit" ]]; then
  name="$(gum input --header="Copyright owner's (you) name" --placeholder="Diana Cavedish")"
  # Why the placeholder is Diana Cavendish? I love Little Witch Academy, it's on Netflix, you should check it out.
  if [[ -n "$name" ]]; then
    sed -i "s/\[fullname\]/$name/" LICENSE.txt
  fi

  sed -i "s/\[year\]/$(date +%Y)/" LICENSE.txt
fi
