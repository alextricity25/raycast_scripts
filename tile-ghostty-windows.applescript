#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Tile Ghostty Windows
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🪟

# Documentation:
# @raycast.author alex_cantu
# @raycast.authorURL https://raycast.com/alex_cantu

use framework "AppKit"

-- Find the screen under the mouse cursor
set mouseLocation to current application's NSEvent's mouseLocation()
set mouseX to (mouseLocation's x) as real
set mouseY to (mouseLocation's y) as real

set allScreens to current application's NSScreen's screens()
set targetScreen to missing value

repeat with s in allScreens
	set {{sX, sY}, {sW, sH}} to (s's frame()) as list
	if mouseX ≥ sX and mouseX < (sX + sW) and mouseY ≥ sY and mouseY < (sY + sH) then
		set targetScreen to s
		exit repeat
	end if
end repeat

if targetScreen is missing value then
	set targetScreen to current application's NSScreen's mainScreen()
end if

-- Derive menu bar height from the primary screen's visible vs full frame.
-- NSScreen reports visibleFrame == frame for non-primary screens even when
-- "Displays have separate Spaces" puts a menu bar on each screen.
set primaryScreen to item 1 of allScreens
set {{_px, _py}, {_pw, primaryHeight}} to (primaryScreen's frame()) as list
set {{_pvx, _pvy}, {_pvw, primaryVisHeight}} to (primaryScreen's visibleFrame()) as list
set primaryHeight to primaryHeight as integer
set menuBarHeight to (primaryHeight as integer) - (primaryVisHeight as integer)

set {{frameX, frameY}, {frameWidth, frameHeight}} to (targetScreen's frame()) as list
set frameX to frameX as integer
set frameY to frameY as integer
set frameWidth to frameWidth as integer
set frameHeight to frameHeight as integer

-- Convert Cocoa coords (bottom-left origin) to System Events coords (top-left origin).
-- System Events uses primary screen's top-left as {0,0} across all monitors.
set screenTopSE to primaryHeight - frameY - frameHeight
set startX to frameX
set startY to screenTopSE + menuBarHeight
set usableWidth to frameWidth
set usableHeight to frameHeight - menuBarHeight

-- Get Ghostty windows and filter to only those on the target screen
set screenRightSE to startX + frameWidth
set screenBottomSE to screenTopSE + frameHeight
set targetIndices to {}

tell application "System Events"
	if not (exists process "Ghostty") then
		return "Ghostty is not running"
	end if
	tell process "Ghostty"
		set totalCount to count of windows
		repeat with i from 1 to totalCount
			set {wx, wy} to position of window i
			if wx ≥ startX and wx < screenRightSE and wy ≥ screenTopSE and wy < screenBottomSE then
				set end of targetIndices to i
			end if
		end repeat
	end tell
end tell

set windowCount to count of targetIndices

if windowCount is 0 then
	return "No Ghostty windows on this screen"
end if

-- Cap at 6 windows
if windowCount > 6 then
	set tileCount to 6
else
	set tileCount to windowCount
end if

-- Ghostty snaps window height to character cell boundaries, so an even
-- split causes both rows to round up and overlap. Use a 35:34 row ratio
-- for 2-row grids to account for this.
set topHeight to (usableHeight * 35 div 69)
set bottomHeight to usableHeight - topHeight

-- Build per-window size/position lists for flexible layouts.
set tileSizes to {}
set tilePositions to {}

if tileCount is 1 then
	set end of tileSizes to {usableWidth, usableHeight}
	set end of tilePositions to {startX, startY}

else if tileCount is 2 then
	set halfW to usableWidth div 2
	set end of tileSizes to {halfW, usableHeight}
	set end of tilePositions to {startX, startY}
	set end of tileSizes to {halfW, usableHeight}
	set end of tilePositions to {startX + halfW, startY}

else if tileCount is 3 then
	-- 1 large left + 2 stacked right
	set halfW to usableWidth div 2
	set end of tileSizes to {halfW, usableHeight}
	set end of tilePositions to {startX, startY}
	set end of tileSizes to {halfW, topHeight}
	set end of tilePositions to {startX + halfW, startY}
	set end of tileSizes to {halfW, bottomHeight}
	set end of tilePositions to {startX + halfW, startY + topHeight}

else if tileCount is 4 then
	-- 2x2 grid
	set halfW to usableWidth div 2
	set end of tileSizes to {halfW, topHeight}
	set end of tilePositions to {startX, startY}
	set end of tileSizes to {halfW, topHeight}
	set end of tilePositions to {startX + halfW, startY}
	set end of tileSizes to {halfW, bottomHeight}
	set end of tilePositions to {startX, startY + topHeight}
	set end of tileSizes to {halfW, bottomHeight}
	set end of tilePositions to {startX + halfW, startY + topHeight}

else if tileCount is 5 then
	-- 2 on top + 3 on bottom
	set halfW to usableWidth div 2
	set thirdW to usableWidth div 3
	set end of tileSizes to {halfW, topHeight}
	set end of tilePositions to {startX, startY}
	set end of tileSizes to {halfW, topHeight}
	set end of tilePositions to {startX + halfW, startY}
	set end of tileSizes to {thirdW, bottomHeight}
	set end of tilePositions to {startX, startY + topHeight}
	set end of tileSizes to {thirdW, bottomHeight}
	set end of tilePositions to {startX + thirdW, startY + topHeight}
	set end of tileSizes to {thirdW, bottomHeight}
	set end of tilePositions to {startX + thirdW * 2, startY + topHeight}

else
	-- 6 windows: 3x2 grid
	set thirdW to usableWidth div 3
	set end of tileSizes to {thirdW, topHeight}
	set end of tilePositions to {startX, startY}
	set end of tileSizes to {thirdW, topHeight}
	set end of tilePositions to {startX + thirdW, startY}
	set end of tileSizes to {thirdW, topHeight}
	set end of tilePositions to {startX + thirdW * 2, startY}
	set end of tileSizes to {thirdW, bottomHeight}
	set end of tilePositions to {startX, startY + topHeight}
	set end of tileSizes to {thirdW, bottomHeight}
	set end of tilePositions to {startX + thirdW, startY + topHeight}
	set end of tileSizes to {thirdW, bottomHeight}
	set end of tilePositions to {startX + thirdW * 2, startY + topHeight}
end if

-- Tile in two passes: resize all first, then position all.
-- This prevents windows from interfering with each other during layout.
tell application "System Events"
	tell process "Ghostty"
		-- Pass 1: resize all target windows
		repeat with idx from 1 to tileCount
			set winIdx to item idx of targetIndices
			set {w, h} to item idx of tileSizes
			set size of window winIdx to {w, h}
		end repeat
		-- Pass 2: position all target windows
		repeat with idx from 1 to tileCount
			set winIdx to item idx of targetIndices
			set {xPos, yPos} to item idx of tilePositions
			set position of window winIdx to {xPos, yPos}
		end repeat
	end tell
end tell

-- Layout description for status message
if tileCount is 1 then
	set layoutDesc to "fullscreen"
else if tileCount is 2 then
	set layoutDesc to "2 columns"
else if tileCount is 3 then
	set layoutDesc to "1+2 split"
else if tileCount is 4 then
	set layoutDesc to "2x2 grid"
else if tileCount is 5 then
	set layoutDesc to "2+3 split"
else
	set layoutDesc to "3x2 grid"
end if

if windowCount > 6 then
	return "Tiled 6 of " & windowCount & " windows (" & layoutDesc & ")"
else
	return "Tiled " & tileCount & " windows (" & layoutDesc & ")"
end if
