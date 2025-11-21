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

## Script Examples

### open-xrdm-ghostty-session.applescript

This script demonstrates AppleScript integration with Ghostty terminal:
- Uses System Events to simulate keyboard shortcuts
- Creates multiple tabs in Ghostty terminal window
- Includes delay timing for UI automation reliability