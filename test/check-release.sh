#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
version=$(sed -n 's/^  version "\([0-9.]*\)"/\1/p' Formula/whitemagic.rb)
test "$version" = '9.3.4'
if [[ $# -eq 0 ]]; then
  release=$(curl -fsSL --retry 2 https://api.github.com/repos/lbailey94/whitemagic/releases/tags/v"$version")
else
  release=$(cat "$1")
fi
jq -e --arg tag "v$version" '(.tag_name // .tag)==$tag' <<<"$release" >/dev/null
count=0
while read -r url digest; do
  url=$(sed "s/#{version}/$version/g" <<<"$url")
  name=${url##*/}
  jq -e --arg name "$name" --arg digest "sha256:$digest" '[.assets[]|select(.name==$name)]|length==1 and .[0].digest==$digest' <<<"$release" >/dev/null
  printf '%s digest matches release metadata\n' "$name"
  count=$((count+1))
done < <(awk '/url "/{u=$2;gsub(/"/,"",u)} /sha256 "/{d=$2;gsub(/"/,"",d);print u,d}' Formula/whitemagic.rb)
test "$count" -eq 4
