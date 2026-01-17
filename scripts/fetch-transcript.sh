#!/bin/bash
# Fetch YouTube video transcript using yt-dlp
# Usage: fetch-transcript.sh <youtube-url>

set -e

URL="$1"

if [ -z "$URL" ]; then
    echo "ERROR: No YouTube URL provided"
    exit 1
fi

# Strict URL validation - must be a real YouTube URL with video ID
# Supports: youtube.com/watch?v=ID, youtu.be/ID, youtube.com/shorts/ID, m.youtube.com/watch?v=ID
if ! echo "$URL" | grep -qE '^https?://(www\.|m\.)?(youtube\.com/(watch\?v=|shorts/)|youtu\.be/)[a-zA-Z0-9_-]+'; then
    echo "ERROR: URL does not appear to be a valid YouTube URL"
    echo "Expected format: https://youtube.com/watch?v=VIDEO_ID or https://youtu.be/VIDEO_ID"
    exit 1
fi

# Function to parse VTT/SRT subtitle files into clean text
parse_subtitles() {
    local file="$1"
    # Remove VTT headers, timestamps, cue numbers, HTML tags, and deduplicate lines
    cat "$file" | \
        grep -vE '^(WEBVTT|Kind:|Language:|NOTE|STYLE)' | \
        grep -vE '^[0-9]+$' | \
        grep -vE '^[0-9]{1,3}:[0-9]{2}(:[0-9]{2})?' | \
        grep -vE '\-\->' | \
        grep -v '^$' | \
        sed 's/<[^>]*>//g' | \
        awk '!seen[$0]++'
}

# Add common install locations to PATH before checking
export PATH="$HOME/.local/bin:$PATH"

# Determine how to run yt-dlp: prefer uvx/pipx run (no install), fallback to installed binary
if command -v uvx &> /dev/null; then
    # uvx runs yt-dlp directly without installing (like npx)
    YTDLP="uvx yt-dlp"
elif command -v pipx &> /dev/null; then
    # pipx run also executes without installing
    YTDLP="pipx run yt-dlp"
elif command -v yt-dlp &> /dev/null; then
    YTDLP="yt-dlp"
else
    # No uvx/pipx and no yt-dlp installed - try to install it
    echo "yt-dlp not found. Attempting to install..."

    # Try brew on macOS/Linux
    if command -v brew &> /dev/null; then
        echo "Installing via brew..."
        brew install yt-dlp 2>/dev/null || true
    # Try winget on Windows
    elif command -v winget &> /dev/null; then
        echo "Installing via winget..."
        winget install yt-dlp --silent 2>/dev/null || true
    # Try scoop on Windows
    elif command -v scoop &> /dev/null; then
        echo "Installing via scoop..."
        scoop install yt-dlp 2>/dev/null || true
    fi

    # Add local bin to PATH in case it was installed there
    export PATH="$HOME/.local/bin:$PATH"

    if command -v yt-dlp &> /dev/null; then
        YTDLP="yt-dlp"
        echo "yt-dlp installed successfully."
    else
        echo "ERROR: Could not find or install yt-dlp."
        echo "Please install one of the following:"
        echo "  - uv (recommended): https://docs.astral.sh/uv/"
        echo "  - pipx: https://pipx.pypa.io/"
        echo "  - brew install yt-dlp (macOS/Linux)"
        echo "  - winget install yt-dlp (Windows)"
        echo "  - scoop install yt-dlp (Windows)"
        exit 1
    fi
fi

# Create temp directory for subtitles and error log
TEMP_DIR=$(mktemp -d)
ERROR_LOG="$TEMP_DIR/yt-dlp-errors.log"
trap 'rm -rf "$TEMP_DIR"' EXIT

# Helper function to find subtitle file (prefer .vtt over .srt)
find_subtitle() {
    local vtt_file=$(find "$TEMP_DIR" -name "*.vtt" 2>/dev/null | head -1)
    if [ -n "$vtt_file" ] && [ -f "$vtt_file" ]; then
        echo "$vtt_file"
        return
    fi
    local srt_file=$(find "$TEMP_DIR" -name "*.srt" 2>/dev/null | head -1)
    if [ -n "$srt_file" ] && [ -f "$srt_file" ]; then
        echo "$srt_file"
    fi
}

# Get video title first
echo "=== VIDEO INFO ==="
$YTDLP --socket-timeout 30 --get-title "$URL" 2>>"$ERROR_LOG" || echo "Could not fetch title"
echo ""

echo "=== TRANSCRIPT ==="

# First try: manual subtitles in English (human-created, higher quality)
if $YTDLP --socket-timeout 30 --write-sub --sub-lang en --skip-download --sub-format vtt --quiet -o "$TEMP_DIR/%(id)s" "$URL" 2>>"$ERROR_LOG"; then
    SUB_FILE=$(find_subtitle)
    if [ -n "$SUB_FILE" ]; then
        parse_subtitles "$SUB_FILE"
        exit 0
    fi
fi

# Second try: auto-generated subtitles in English
if $YTDLP --socket-timeout 30 --write-auto-sub --sub-lang en --skip-download --sub-format vtt --quiet -o "$TEMP_DIR/%(id)s" "$URL" 2>>"$ERROR_LOG"; then
    SUB_FILE=$(find_subtitle)
    if [ -n "$SUB_FILE" ]; then
        parse_subtitles "$SUB_FILE"
        exit 0
    fi
fi

# Third try: any available subtitles (any language)
if $YTDLP --socket-timeout 30 --write-auto-sub --write-sub --skip-download --sub-format vtt --quiet -o "$TEMP_DIR/%(id)s" "$URL" 2>>"$ERROR_LOG"; then
    SUB_FILE=$(find_subtitle)
    if [ -n "$SUB_FILE" ]; then
        parse_subtitles "$SUB_FILE"
        exit 0
    fi
fi

echo "ERROR: No transcript/subtitles available for this video"
echo "This video may not have captions enabled."
# Show any errors from yt-dlp for debugging
if [ -s "$ERROR_LOG" ]; then
    echo ""
    echo "Debug info (yt-dlp errors):"
    cat "$ERROR_LOG"
fi
exit 1
