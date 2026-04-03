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

    if branchName is "main" then
        set workDir to "~/Development/xrdm"
    else
        set workDir to "~/Development/" & branchName
    end if

    -- Optional second argument: a prompt to pass to claude code
    if (count of argv) > 1 then
        set claudePrompt to item 2 of argv
    else
        set claudePrompt to ""
    end if

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

            if branchName is not "main" then
                -- Fetch remote, then create worktree: track remote branch if it exists, otherwise create new branch from HEAD
                keystroke "git fetch origin && git worktree add ../" & branchName & " " & branchName & " 2>/dev/null || git worktree add -b " & branchName & " ../" & branchName & " 2>/dev/null || true"
                delay 0.2

                -- Press Enter to confirm
                key code 36 -- Return key
            end if

            -- Change the xrdm repo that corresponds to the worktree
            keystroke "cd " & workDir
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

            -- Type the branch name for tab 1
            keystroke "xrdm " & branchName & " - lazygit"
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key


            -- Tab 2 ------------------------------
            keystroke "t" using command down
            delay 1.5

            -- cd to the worktree directory
            keystroke "cd " & workDir
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

            -- Type the branch name for tab 2
            keystroke "xrdm " & branchName & " - k9s"
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key
            -- End Tab 2 --------------------------


            -- Tab 3 ------------------------------
            keystroke "t" using command down
            delay 1.5

            -- cd to the worktree directory
            keystroke "cd " & workDir
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

            -- Type the branch name for tab 2
            keystroke "xrdm " & branchName & " - code"
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key

            if branchName is not "main" then
                -- Copy necessary files over from main worktree
                keystroke "cp /Users/alexcantu/Development/xrdm/devops/apps/idp/.env " & workDir & "/devops/apps/idp"
                delay 0.2

                -- Press Enter to confirm
                key code 36 -- Return key

                -- Copy necessary files over from main worktree
                keystroke "cp /Users/alexcantu/Development/xrdm/devops/apps/idp/CLAUDE.md " & workDir & "/devops/apps/idp"
                delay 0.2

                -- Press Enter to confirm
                key code 36 -- Return key
            end if
            -- End Tab 3 --------------------------


            -- Tab 4 (Claude Code) ----------------
            keystroke "t" using command down
            delay 1.5

            -- Open command palette (Cmd+Shift+P)
            keystroke "p" using {command down, shift down}
            delay 0.3

            -- Type "change tab title"
            keystroke "change tab title"
            delay 0.5

            -- Press Enter to select the command
            key code 36 -- Return key
            delay 0.5

            -- Type the tab title
            keystroke "xrdm " & branchName & " - claude"
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key

            -- cd to the worktree
            keystroke "cd " & workDir
            delay 0.2

            -- Press Enter
            key code 36 -- Return key
            delay 0.5

            -- Run claude code, with optional handoff prompt
            if claudePrompt is not "" then
                keystroke "claude --allowedTools \"Edit,Write,mcp__linear-server__*,mcp__claude_ai_Slack__*\" \"" & claudePrompt & "\""
            else
                keystroke "claude"
            end if
            delay 0.2

            -- Press Enter
            key code 36 -- Return key
            -- End Tab 4 --------------------------

        end tell
    end tell
end run
