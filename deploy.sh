#!/usr/bin/env bash
# Deploy the game to itch.io using butler.
#
# One-time setup on your local machine:
#   1. Create the game page on itch.io first (empty is fine):
#        https://itch.io/game/new  ->  "Kind of project: HTML"  ->  save
#      Note the URL slug — e.g. https://you.itch.io/beneath-the-branches
#   2. Install butler:  https://itch.io/docs/butler/installing.html
#        macOS:   brew install itch/tap/butler
#        Linux:   download https://broth.itch.zone/butler/linux-amd64/LATEST/archive/default
#        Windows: download https://broth.itch.zone/butler/windows-amd64/LATEST/archive/default
#   3. Get an API key at  https://itch.io/user/settings/api-keys
#
# Then, from this repo:
#   BUTLER_API_KEY=xxxxx ITCH_USER=yourname ITCH_GAME=beneath-the-branches ./deploy.sh
#
# Subsequent updates just re-run the same command — butler diffs against the
# previous upload and only sends changed bytes.

set -euo pipefail

: "${BUTLER_API_KEY:?Set BUTLER_API_KEY (get one at https://itch.io/user/settings/api-keys)}"
: "${ITCH_USER:?Set ITCH_USER (your itch.io username)}"
: "${ITCH_GAME:?Set ITCH_GAME (the game slug you created, e.g. beneath-the-branches)}"

ZIP="${ZIP:-game.zip}"
CHANNEL="${CHANNEL:-html}"   # itch.io recognizes "html" as a web-embed channel

if [[ ! -f "$ZIP" ]]; then
  echo "Building $ZIP from dist/ ..."
  ( cd dist && zip -qr "../$ZIP" . )
fi

VERSION="$(date -u +%Y.%m.%d-%H%M)"
TARGET="$ITCH_USER/$ITCH_GAME:$CHANNEL"

echo "Uploading $ZIP  ->  $TARGET  (version $VERSION)"
butler push "$ZIP" "$TARGET" --userversion "$VERSION"

echo
echo "Uploaded. Now on itch.io:"
echo "  1. Open  https://itch.io/dashboard  ->  Edit game  ->  Uploads"
echo "  2. Tick the box on the html5 upload:  'This file will be played in the browser'"
echo "  3. Under 'Embed options', set width/height to  1280 x 800  (or Fullscreen)"
echo "  4. Save & publish."
