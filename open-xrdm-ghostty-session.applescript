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
    set mainRepo to "~/Development/xrdm"

    -- Extract the Linear issue ID (e.g. PLA-1234) from the branch name
    if branchName is not "main" then
        try
            set issueID to do shell script "echo " & quoted form of branchName & " | grep -oiE '[a-z]+-[0-9]+' | head -1 | tr '[:lower:]' '[:upper:]'"
        on error
            set issueID to ""
        end try
    else
        set issueID to ""
    end if

    -- Look up the Linear issue and generate a terse tab label
    if issueID is not "" then
        try
            set shortDescription to do shell script "echo 'Extract the Linear issue ID from this branch name: " & branchName & ". Look up the issue and generate a terse 3-4 word tab label describing the task. Output ONLY the label, nothing else.' | claude -p --allowedTools 'mcp__linear-server__get_issue'"
        on error
            set shortDescription to ""
        end try
    else
        set shortDescription to ""
    end if

    -- Build the tab label prefix (e.g. "Fix Auth Flow")
    if shortDescription is not "" then
        set tabLabel to shortDescription
    else
        set tabLabel to branchName
    end if

    if branchName is "main" then
        set workDir to mainRepo
    else
        set workDir to mainRepo & "/.claude/worktrees/" & branchName
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

            -- Change to the main repo
            keystroke "cd " & mainRepo
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key

            if branchName is not "main" then
                -- Ensure worktree parent directory exists, fetch remote, then create worktree
                keystroke "mkdir -p .claude/worktrees && git fetch origin && git worktree add .claude/worktrees/" & branchName & " " & branchName & " 2>/dev/null || git worktree add -b " & branchName & " .claude/worktrees/" & branchName & " 2>/dev/null || true"
                delay 0.2

                -- Press Enter to confirm
                key code 36 -- Return key
            end if

            -- Change to the worktree directory
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

            -- Type the tab title for tab 1
            keystroke tabLabel & " - lg"
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

            -- Type the tab title for tab 2
            keystroke tabLabel & " - k9"
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

            -- Type the tab title for tab 3
            keystroke tabLabel & " - code"
            delay 0.2

            -- Press Enter to confirm
            key code 36 -- Return key
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

            -- Type the tab title for tab 4
            keystroke tabLabel & " - cc"
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
