#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
version=$(sed -n 's|.*url ".*/v\([0-9.]*\)/.*|\1|p' Formula/whitemagic.rb | sort -u)
test "$version" = '9.3.4'
if [[ $# -eq 0 ]]; then
  auth=()
  if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    auth=(-H "Authorization: Bearer $GITHUB_TOKEN")
  fi
  release=$(curl -fsSL --retry 2 "${auth[@]}" https://api.github.com/repos/lbailey94/whitemagic/releases/tags/v"$version")
else
  release=$(cat "$1")
fi
jq -e --arg tag "v$version" '(.tag_name // .tag)==$tag' <<<"$release" >/dev/null
count=0
while read -r url digest; do
  name=${url##*/}
  jq -e --arg name "$name" --arg digest "sha256:$digest" '[.assets[]|select(.name==$name)]|length==1 and .[0].digest==$digest' <<<"$release" >/dev/null
  printf '%s digest matches release metadata\n' "$name"
  count=$((count+1))
done < <(awk '/url "/{u=$2;gsub(/"/,"",u)} /sha256 "/{d=$2;gsub(/"/,"",d);print u,d}' Formula/whitemagic.rb)
test "$count" -eq 4
