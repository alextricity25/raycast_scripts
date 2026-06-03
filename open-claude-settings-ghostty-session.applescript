#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Claude Settings
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author alex_cantu
# @raycast.authorURL https://raycast.com/alex_cantu

on run argv
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
            delay 1.5

            -- Change to the ~/.claude directory
            keystroke "cd ~/.claude/"
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key

            -- Run lazygit
            keystroke "lazygit"
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key

            -- Open command palette (Cmd+Shift+P)
            keystroke "p" using {command down, shift down}
            delay 0.3

            -- Type "change tab title"
            keystroke "change tab title"
            delay 0.5

            -- Press Enter to select the command
            key code 36 -- Return key
            delay 0.5

            -- Type the title for lazygit tab
            keystroke ".claude - lazygit"
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key


            -- Tab 2 ------------------------------
            keystroke "t" using command down
            delay 1.5

            -- cd to the ~/.claude directory
            keystroke "cd ~/.claude/"
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key
            delay 0.5

            -- Open command palette (Cmd+Shift+P)
            keystroke "p" using {command down, shift down}
            delay 0.3

            -- Type "change tab title"
            keystroke "change tab title"
            delay 0.5

            -- Press Enter to select the command
            key code 36 -- Return key
            delay 0.5

            -- Type the title for code tab
            keystroke ".claude - code"
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key
            -- End Tab 2 --------------------------


            -- Tab 3 ------------------------------
            keystroke "t" using command down
            delay 1.5

            -- cd to the ~/.claude directory
            keystroke "cd ~/.claude/"
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key
            delay 0.5

            -- Launch Claude Code
            keystroke "claude"
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key
            delay 0.5

            -- Open command palette (Cmd+Shift+P)
            keystroke "p" using {command down, shift down}
            delay 0.3

            -- Type "change tab title"
            keystroke "change tab title"
            delay 0.5

            -- Press Enter to select the command
            key code 36 -- Return key
            delay 0.5

            -- Type the title for claude tab
            keystroke ".claude - claude"
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key
            -- End Tab 3 --------------------------
        end tell
    end tell
end run
