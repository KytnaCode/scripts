#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash gum jq
# shellcheck shell=bash

licenses_res="$(curl \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/licenses)"

licenses_pairs="$(jq '.[] | [.key, .name] | join(" --- ")' <<<"$licenses_res" | sed -e 's/^"//' -e 's/"$//')"

options="$(printf "%s\nnone" "$licenses_pairs")" # Add none option.

license="$(gum filter <<<"$options" | sed 's/ --- .*//')"

if [[ "$license" == none || -z "$license" ]]; then
  exit 0
fi

license_content="$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/licenses/$license" | jq --raw-output '.body')"

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
