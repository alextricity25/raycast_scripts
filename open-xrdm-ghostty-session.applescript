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
            delay 1.5

            -- Change the xrdm repo
            keystroke "cd ~/Development/xrdm"
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key

            -- Change the xrdm repo
            keystroke "git worktree add -b " & branchName & " ../" & branchName & " || cd ../" & branchName
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

            -- Type "change title"
            keystroke "change title"
            delay 0.5

            -- Press Enter to select the command
            key code 36 -- Return key
            delay 0.5

            -- Type the branch name for tab 1
            keystroke "xrdm " & branchName & " - lazygit"
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key


            -- Tab 2 ------------------------------
            keystroke "t" using command down
            delay 0.5

            -- Open command palette (Cmd+Shift+P)
            keystroke "p" using {command down, shift down}
            delay 0.3

            -- Type "change title"
            keystroke "change title"
            delay 0.5

            -- Press Enter to select the command
            key code 36 -- Return key
            delay 0.5

            -- Type the branch name for tab 2
            keystroke "xrdm " & branchName & " - k9s"
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key
            -- End Tab 2 --------------------------


            -- Tab 3 ------------------------------
            keystroke "t" using command down
            delay 0.5

            -- Open command palette (Cmd+Shift+P)
            keystroke "p" using {command down, shift down}
            delay 0.3

            -- Type "change title"
            keystroke "change title"
            delay 0.5

            -- Press Enter to select the command
            key code 36 -- Return key
            delay 0.5

            -- Type the branch name for tab 2
            keystroke "xrdm " & branchName & " - infra"
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key

            -- Change the xrdm infra dir
            keystroke "cd devops/infrastructure/xrdm"
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key
            -- End Tab 3 --------------------------


            -- Tab 4 ------------------------------
            keystroke "t" using command down
            delay 0.5

            -- Open command palette (Cmd+Shift+P)
            keystroke "p" using {command down, shift down}
            delay 0.3

            -- Type "change title"
            keystroke "change title"
            delay 0.5

            -- Press Enter to select the command
            key code 36 -- Return key
            delay 0.5

            -- Type the branch name for tab 2
            keystroke "xrdm " & branchName & " - idp"
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key

            -- Change the xrdm idp app repo
            keystroke "cd devops/apps/idp"
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key
            -- End Tab 4 --------------------------

        end tell
    end tell
end run
