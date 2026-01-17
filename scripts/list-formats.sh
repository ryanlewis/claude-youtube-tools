#!/bin/bash
# List available video formats for a YouTube video
# Usage: list-formats.sh <youtube-url>

set -e

URL="$1"

if [ -z "$URL" ]; then
    echo "ERROR: No YouTube URL provided"
    exit 1
fi

# Strict URL validation
if ! echo "$URL" | grep -qE '^https?://(www\.|m\.)?(youtube\.com/(watch\?v=|shorts/)|youtu\.be/)[a-zA-Z0-9_-]+'; then
    echo "ERROR: URL does not appear to be a valid YouTube URL"
    exit 1
fi

# Add common install locations to PATH
export PATH="$HOME/.local/bin:$PATH"

# Determine how to run yt-dlp
if command -v uvx &> /dev/null; then
    YTDLP="uvx yt-dlp"
elif command -v pipx &> /dev/null; then
    YTDLP="pipx run yt-dlp"
elif command -v yt-dlp &> /dev/null; then
    YTDLP="yt-dlp"
else
    echo "ERROR: yt-dlp not found. Please install yt-dlp first."
    exit 1
fi

# Get video title
TITLE=$($YTDLP --get-title "$URL" 2>/dev/null || echo "Unknown Title")
echo "Video: $TITLE"
echo ""

# List formats and extract the useful video formats with resolution
echo "Available formats:"
$YTDLP -F "$URL" 2>/dev/null | tail -n +4 | while read -r line; do
    # Only show lines with resolution info (video formats)
    if echo "$line" | grep -qE '[0-9]+x[0-9]+|[0-9]+p'; then
        echo "  $line"
    fi
done

echo ""
echo "Quality shortcuts: best, 1080p, 720p, 480p, 360p"
