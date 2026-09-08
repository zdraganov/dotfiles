#!/usr/bin/env bash
# Push the values from iterm2/zdraganov.json into iTerm2's *Default* profile.
#
# Why: a dynamic profile cannot reliably be the default — iTerm2 reads its
# preferences before it reloads DynamicProfiles/, so "Set as Default" on one
# falls back to the built-in profile on the next launch. Writing the same values
# into the Default profile sidesteps that. Run it with iTerm2 closed.
set -euo pipefail

JSON="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/zdraganov.json"
DOMAIN=com.googlecode.iterm2

if pgrep -xq iTerm2; then
  echo "iTerm2 is running — quit it first (Cmd+Q), then re-run." >&2
  exit 1
fi

TMP="$(mktemp -d)/iterm2.plist"
defaults export "$DOMAIN" "$TMP"

python3 - "$TMP" "$JSON" <<'PY'
import json, plistlib, sys
plist_path, json_path = sys.argv[1:3]
with open(plist_path, "rb") as f:
    prefs = plistlib.load(f)
profile = json.load(open(json_path))["Profiles"][0]

bookmarks = prefs.setdefault("New Bookmarks", [])
default_guid = prefs.get("Default Bookmark Guid")
target = next((b for b in bookmarks if b.get("Guid") == default_guid), None) \
      or next((b for b in bookmarks if b.get("Name") == "Default"), None)
if target is None:
    target = {"Name": "Default", "Guid": "7ACD5AE2-B49E-41E1-B4A4-04E34D9DEA59"}
    bookmarks.append(target)
prefs["Default Bookmark Guid"] = target["Guid"]

changed = []
for k, v in profile.items():
    if k in ("Name", "Guid"):
        continue
    if target.get(k) != v:
        target[k] = v
        changed.append(k)

with open(plist_path, "wb") as f:
    plistlib.dump(prefs, f)
print(f"updated {len(changed)} key(s) in profile '{target['Name']}': " + ", ".join(sorted(changed)[:8]) + (" …" if len(changed) > 8 else ""))
PY

defaults import "$DOMAIN" "$TMP"
rm -rf "$(dirname "$TMP")"
echo "done — open iTerm2."
