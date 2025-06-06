#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Add Notes
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName add-to-notes

# Documentation:
# @raycast.author Siddhant Zawar

# Argument definition:
# @raycast.argument1 { "type": "text", "placeholder": "Folder Name : Content" }

on run argv
    log "Raycast test script executed successfully!"
    set inputText to item 1 of argv
    set clipboardText to the clipboard
    
    -- Parse the input to extract folder name and content
    set folderName to text 1 through ((offset of ":" in inputText) - 1) of inputText
    set noteContent to text ((offset of ":" in inputText) + 2) through (length of inputText) of inputText
    
    -- Check if clipboardText is a link
    if clipboardText starts with "http://" or clipboardText starts with "https://" then
        set noteContent to noteContent & " <a href=\"" & clipboardText & "\">" & clipboardText & "</a> "
    else
        set noteContent to noteContent & " " & clipboardText
    end if
    
    tell application "Notes"
        activate
        -- Find the target folder
        set targetFolderRef to folder folderName
        
        -- Search for the "TODO Items" note in the folder
        set todoNote to missing value
        repeat with n in notes of targetFolderRef
            if name of n is "TODO Items" then
                set todoNote to n
                exit repeat
            end if
        end repeat
        
        -- If the note exists, append the new checklist item; otherwise, create a new note
        if todoNote is not missing value then
            -- Append checklist item starting with a new line
            set body of todoNote to (body of todoNote & return & return & "- [ ] " & noteContent)
        else
            -- Create a new note with the checklist item
            set newNote to make new note at targetFolderRef with properties {name:"TODO Items", body:"- [ ] " & noteContent & " "}
        end if
    end tell
    
    log "Note updated successfully in folder: " & folderName & " with content: " & noteContent
end run

