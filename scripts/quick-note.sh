#!/bin/bash

# Configuration
OBSIDIAN_VAULT="$HOME/Documents/Notes/Mindflayer"    # Path to your notes directory
DAILY_NOTES_FOLDER="Quick Notes"                     # Folder for Quick Notes
DATE_FORMAT="%Y-%m-%d"                              # Filename date format
READABLE_DATE_FORMAT="%B %d, %Y"                    # Human-readable date format
CONFIG_FILE="$HOME/.config/quick-notes/config"      # Config file path

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display usage instructions
usage() {
    echo -e "${YELLOW}Usage:${NC} note [-w|-p|-f] [-t tags] \"Your note content\""
    echo "Options:"
    echo "  -w : Work notes"
    echo "  -p : Personal notes"
    echo "  -f : Freelance notes"
    echo "  -t : Additional tags (comma-separated)"
    echo -e "${GREEN}Examples:${NC}"
    echo "  note -w \"Discuss Q1 goals\""
    echo "  note -w -t meeting,followup \"Team sync notes\""
    exit 1
}

# Function to load configuration
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    else
        # Create config directory if it doesn't exist
        mkdir -p "$(dirname "$CONFIG_FILE")"
        # Create default config
        cat > "$CONFIG_FILE" << EOL
OBSIDIAN_VAULT="$HOME/Documents/Notes/Mindflayer"
DAILY_NOTES_FOLDER="Quick Notes"
DATE_FORMAT="%Y-%m-%d"
READABLE_DATE_FORMAT="%B %d, %Y"
EOL
    fi
}

# Function to validate directory
validate_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1" || {
            echo -e "${RED}Error: Failed to create directory $1${NC}"
            exit 1
        }
    fi
}

# Parse command line arguments
TAGS=""
while getopts ":wpft:" opt; do
    case $opt in
        w) CATEGORY="work";;
        p) CATEGORY="personal";;
        f) CATEGORY="freelance";;
        t) TAGS="$OPTARG";;
        \?)
            echo -e "${RED}Error: Invalid option -$OPTARG${NC}" >&2
            usage
            ;;
    esac
done

# Shift past the options
shift $((OPTIND-1))

# Check if note content is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Note content is required${NC}"
    usage
fi

# Load configuration
load_config

# Get the note content
NOTE_CONTENT="$1"

# Format dates
TODAY=$(date +"$DATE_FORMAT")
READABLE_DATE=$(date +"$READABLE_DATE_FORMAT")
TIMESTAMP=$(date +"%H%M")

# Setup paths
NOTE_FILE="$OBSIDIAN_VAULT/$DAILY_NOTES_FOLDER/Quick_Notes.md"

# Validate directories
validate_dir "$OBSIDIAN_VAULT"
validate_dir "$OBSIDIAN_VAULT/$DAILY_NOTES_FOLDER"

# Create or update note file
if [ ! -f "$NOTE_FILE" ]; then
    echo "# Quick Notes" > "$NOTE_FILE"
fi

# Prepare tags
ALL_TAGS="#$CATEGORY"
if [ ! -z "$TAGS" ]; then
    # Convert comma-separated tags to hashtags
    FORMATTED_TAGS=$(echo $TAGS | sed 's/,/ #/g')
    ALL_TAGS=" $ALL_TAGS #$FORMATTED_TAGS"
fi

# Add date header if it doesn't exist
if ! grep -q "## $READABLE_DATE" "$NOTE_FILE"; then
    echo -e "\n---\n" >> "$NOTE_FILE"
    echo "## $READABLE_DATE" >> "$NOTE_FILE"
    echo "" >> "$NOTE_FILE"
fi

# Add the note with timestamp and tags
echo "- [ ] **$TIMESTAMP**: $NOTE_CONTENT ( $ALL_TAGS )" >> "$NOTE_FILE"

# Confirmation message
echo -e "${GREEN}✓ Note added to Quick Notes${NC}"
