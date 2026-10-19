#!/usr/bin/env bash
set -euo pipefail

usage() {
    printf 'Usage: %s enable|update IMAGE [CHROME_PROFILE_DIR]\n' "$0" >&2
    printf 'Default profile: ~/.config/google-chrome/Default\n' >&2
    exit 2
}

[[ $# -ge 2 && $# -le 3 ]] || usage
mode=$1
src=$2
profile=${3:-${CHROME_PROFILE_DIR:-"$HOME/.config/google-chrome/Default"}}

case "$mode" in
    enable|update) ;;
    *) usage ;;
esac

[[ -f "$src" ]] || { printf 'Image not found: %s\n' "$src" >&2; exit 1; }
[[ -d "$profile" ]] || { printf 'Chrome profile directory not found: %s\n' "$profile" >&2; exit 1; }
command -v file >/dev/null || { printf 'Missing dependency: file\n' >&2; exit 1; }

prefs="$profile/Preferences"
if [[ "$mode" == enable ]]; then
    [[ -f "$prefs" ]] || { printf 'Preferences file not found: %s\n' "$prefs" >&2; exit 1; }
    command -v jq >/dev/null || { printf 'Missing dependency: jq\n' >&2; exit 1; }
    if pgrep -x chrome >/dev/null 2>&1 || pgrep -x google-chrome >/dev/null 2>&1; then
        printf 'Quit Chrome completely before running enable (including background processes).\n' >&2
        exit 1
    fi
fi

tmp_image=
tmp_prefs=
cleanup() {
    [[ -z "$tmp_image" ]] || rm -f -- "$tmp_image"
    [[ -z "$tmp_prefs" ]] || rm -f -- "$tmp_prefs"
}
trap cleanup EXIT

tmp_image=$(mktemp --tmpdir="$profile" --suffix=.jpg '.background.XXXXXX')
mime=$(file --brief --mime-type -- "$src")
if [[ "$mime" == image/jpeg ]]; then
    cp -- "$src" "$tmp_image"
elif command -v magick >/dev/null 2>&1; then
    magick "$src" -strip -quality 92 "$tmp_image"
elif command -v convert >/dev/null 2>&1; then
    convert "$src" -strip -quality 92 "$tmp_image"
elif command -v ffmpeg >/dev/null 2>&1; then
    ffmpeg -hide_banner -loglevel error -y -i "$src" -frames:v 1 -q:v 2 "$tmp_image"
else
    printf 'Input is %s, not JPEG. Install ImageMagick or ffmpeg to convert it.\n' "$mime" >&2
    exit 1
fi
[[ -s "$tmp_image" ]] || { printf 'Could not create background JPEG.\n' >&2; exit 1; }
mv -f -- "$tmp_image" "$profile/background.jpg"
tmp_image=

if [[ "$mode" == enable ]]; then
    backup="$prefs.bak.$(date +%Y%m%d-%H%M%S)"
    cp -p -- "$prefs" "$backup"
    tmp_prefs=$(mktemp --tmpdir="$profile" '.Preferences.XXXXXX')
    jq '.ntp = ((.ntp // {}) + {
        "custom_background_local_to_device": true,
        "custom_background_local_to_device_id": "",
        "custom_background_inspiration": false
    })' "$prefs" > "$tmp_prefs"
    chmod --reference="$prefs" "$tmp_prefs"
    mv -f -- "$tmp_prefs" "$prefs"
    tmp_prefs=
    printf 'Enabled Chrome local New Tab background in %s\n' "$profile"
    printf 'Preference backup: %s\n' "$backup"
else
    printf 'Updated %s/background.jpg\n' "$profile"
fi
