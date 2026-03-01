#!/usr/bin/env nix
#! nix shell nixpkgs#bash nixpkgs#jq --command bash
# shellcheck shell=bash

shopt -s lastpipe

fetch_license() {
  curl -L \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/licenses/$1" | jq '.body'
}

licenses_res="$(curl \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/licenses | jq 'map( { (.key|tostring): {name} }) | add')"

jq -c -r 'keys[]' <<<"$licenses_res" |
  while read -r key; do
    licenses_res="$(jq -c ".[\"$key\"].body=$(fetch_license "$key")" <<<"$licenses_res")"
  done

jq -c <<<"$licenses_res" >licenses.json
