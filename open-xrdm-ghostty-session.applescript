#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open XRDM Ghostty Session
# @raycast.mode compact
# @raycast.argument1 { "type": "text", "placeholder": "Tab Title" }

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author alex_cantu
# @raycast.authorURL https://raycast.com/alex_cantu

on run argv
	set tabTitle to item 1 of argv

	tell application "Ghostty"
		activate

		-- Create a new window (first tab)
		tell application "System Events"
			keystroke "n" using {command down}
			delay 0.5

			-- Set the title of the first tab using escape sequence
			keystroke "printf '\\033]0;" & tabTitle & "\\007'" as text
			keystroke return
			delay 0.3

			-- Create second tab
			keystroke "t" using {command down}
			delay 0.5

			-- Create third tab
			keystroke "t" using {command down}
		end tell
	end tell
end run

