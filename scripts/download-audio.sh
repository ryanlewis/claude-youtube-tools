#!/bin/bash
# Download audio from a YouTube video
# Usage: download-audio.sh <youtube-url> [format]
# Format: mp3 (default, requires ffmpeg), best (native format)

set -e

URL="$1"
FORMAT="${2:-mp3}"

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

echo "Downloading audio..."

# Check if ffmpeg is available
if command -v ffmpeg &> /dev/null; then
    # ffmpeg available: convert to requested format with thumbnail
    $YTDLP -x --audio-format "$FORMAT" --audio-quality 192K \
        --embed-thumbnail \
        -o "%(title)s.%(ext)s" --restrict-filenames \
        --progress "$URL"
else
    # No ffmpeg: download best audio in native format
    echo "Note: ffmpeg not found, downloading in original format (usually m4a/webm)"
    $YTDLP -f "bestaudio" \
        -o "%(title)s.%(ext)s" --restrict-filenames \
        --progress "$URL"
fi

echo ""
echo "Download complete!"
