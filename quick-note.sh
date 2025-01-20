#!/bin/bash

# Configuration
OBSIDIAN_VAULT="$HOME/Documents/Notes/Mindflayer" # Path to your Obsidian vault
DAILY_NOTES_FOLDER="Quick Notes"                 # Folder for Quick Notes
DATE_FORMAT="%Y-%m-%d"                           # Filename date format
READABLE_DATE_FORMAT="%B %d, %Y"                 # Human-readable date format
DEFAULT_TAG="office"                             # Default tag if none is provided

# Function to display usage instructions
usage() {
    echo "Usage: note -w/-p/-f \"Your note content\""
    echo "  -w : Work"
    echo "  -p : Personal"
    echo "  -f : Freelance"
    echo "Example: note -w \"Discuss Q1 goals\""
    exit 1
}

# Check if a tag flag and note content are provided
if [ $# -lt 2 ]; then
    usage
fi

# Parse the tag flag
case "$1" in
    -w) TAG="work" ;;
    -p) TAG="personal" ;;
    -f) TAG="freelance" ;;
    *) 
        echo "Error: Invalid tag flag"
        usage
        ;;
esac

# Get the note content
NOTE_CONTENT=$2

# Get today's date in both formats
TODAY=$(date +"$DATE_FORMAT")
READABLE_DATE=$(date +"$READABLE_DATE_FORMAT")

# Path to the Quick Notes file
NOTE_FILE="$OBSIDIAN_VAULT/$DAILY_NOTES_FOLDER/Quick_Notes.md"

# Ensure the Obsidian vault directory exists
if [ ! -d "$OBSIDIAN_VAULT" ]; then
    echo "Error: Obsidian vault directory not found at $OBSIDIAN_VAULT"
    exit 1
fi

# Create the Quick Notes folder if it doesn't exist
mkdir -p "$OBSIDIAN_VAULT/$DAILY_NOTES_FOLDER"

# Create the Quick Notes file if it doesn't exist
if [ ! -f "$NOTE_FILE" ]; then
    echo "# Quick Notes" > "$NOTE_FILE"
fi

# Check if today's date header exists in the file
if ! grep -q "## $READABLE_DATE" "$NOTE_FILE"; then
    echo -e "\n---\n" >> "$NOTE_FILE"         # Add a divider for separation
    echo "## $READABLE_DATE" >> "$NOTE_FILE"  # Add the readable date as a secondary header
    echo "" >> "$NOTE_FILE"                   # Add a blank line
fi

# Get the current timestamp in "1300" format
TIMESTAMP=$(date +"%H%M")

# Append the note with a checkbox, bold timestamp, and tags
echo "- [ ] **$TIMESTAMP**: $NOTE_CONTENT ( #$TAG )" >> "$NOTE_FILE"

# Confirmation message
echo "Note added to $NOTE_FILE"
