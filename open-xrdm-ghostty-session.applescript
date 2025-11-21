#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open XRDM Ghostty Session
# @raycast.mode compact
# @raycast.argument1 { "type": "text", "placeholder": "Branch Name" }

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author alex_cantu
# @raycast.authorURL https://raycast.com/alex_cantu

on run argv
    set branchName to item 1 of argv

    -- Dismiss Raycast first
    tell application "System Events"
        key code 53 -- Escape key
        delay 0.3
    end tell

    tell application "Ghostty"
        activate
        delay 0.5
    end tell

    tell application "System Events"
        tell process "Ghostty"
            -- Open new window (Cmd+N)
            keystroke "n" using command down
        end tell
    end tell
end run
