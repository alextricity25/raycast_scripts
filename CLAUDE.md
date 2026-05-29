# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a collection of Raycast Script Commands. Raycast scripts are executable files that integrate with the Raycast launcher on macOS, allowing quick automation tasks from the command bar.

## Architecture

### Script Types

This repository contains two types of scripts:

1. **Shell Scripts** (`.sh` files) - Bash scripts for command-line operations
2. **AppleScript** (`.applescript` files) - Scripts for macOS system automation and application control

### Raycast Metadata Format

All Raycast scripts must include special comment metadata at the top of the file:

**Required parameters:**
- `@raycast.schemaVersion` - Currently 1
- `@raycast.title` - Display name shown in Raycast
- `@raycast.mode` - Output mode (`fullOutput`, `compact`, `silent`, or `inline`)

**Optional parameters:**
- `@raycast.icon` - Emoji icon displayed in Raycast
- `@raycast.packageName` - Grouping name for related scripts
- `@raycast.argument1` - JSON object for script arguments: `{ "type": "text", "placeholder": "Name" }`
- `@raycast.author` - Author username
- `@raycast.authorURL` - Author profile URL

### Script Structure

- **Shell scripts**: Use `#!/bin/bash` shebang and Raycast metadata in comments starting with `#`
- **AppleScript**: Use `#!/usr/bin/osascript` shebang and Raycast metadata in comments starting with `#`
- All scripts must be executable (`chmod +x`)

## Development Workflow

### Creating New Scripts

1. Duplicate `script-command.template.sh` and rename it (remove `.template.` from filename)
2. Add appropriate shebang based on script type
3. Configure Raycast metadata comments
4. Implement script functionality
5. Make executable: `chmod +x <script-name>`
6. Refresh Raycast script commands to test

### Testing Scripts

Scripts can be tested directly from the command line:
```bash
./<script-name>.sh
```

Or for AppleScript:
```bash
osascript <script-name>.applescript
```

## Scripts

- **open-xrdm-ghostty-session.applescript** - Opens a multi-tab Ghostty session for xrdm development (lazygit, code, k9s, Claude Code tabs) with git worktree support. Accepts a branch name argument and optionally a Claude Code prompt.
- **open-appn-ghostty-session.applescript** - Opens a multi-tab Ghostty session for appn development (lazygit, code, Claude Code tabs) with git worktree support. Accepts a branch name argument and optionally a Claude Code prompt.
- **open-raycast-scripts-ghostty-session.applescript** - Opens a multi-tab Ghostty session for this raycast_scripts repo (lazygit, code, Claude Code tabs).
- **tile-ghostty-windows.applescript** - Tiles up to 6 Ghostty windows into a grid on the screen under the mouse cursor. Uses NSScreen/AppKit for multi-monitor support.

## AppleScript Gotchas

### NSScreen Coordinate Conversion
- Cocoa uses bottom-left origin; System Events uses top-left origin (relative to primary screen)
- Convert: `SE_y = primaryScreenHeight - cocoaY - windowHeight`
- Destructure NSRect as a list, not with dot notation: `set {{x, y}, {w, h}} to (screen's frame()) as list`

### Multi-Monitor Menu Bar
- `NSScreen visibleFrame` equals `frame` on non-primary screens, even when "Displays have separate Spaces" is on
- Derive menu bar height from the primary screen: `primaryFrameHeight - primaryVisibleHeight`
- Apply that offset to all screens

### Ghostty Window Automation
- Ghostty snaps window sizes to character cell boundaries — requesting an exact pixel height may result in a different actual height
- When tiling, resize all windows first (pass 1), then position them (pass 2) to prevent macOS from shifting windows
- Filter windows by screen position to avoid moving windows across monitors
- Use `tell application "System Events" to tell process "Ghostty"` for window manipulation (Ghostty's own scripting dictionary is minimal)