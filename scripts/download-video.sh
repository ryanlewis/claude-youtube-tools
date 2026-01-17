#!/bin/bash
# Download a YouTube video with specified quality
# Usage: download-video.sh <youtube-url> [quality]
# Quality: best, 1080p, 720p, 480p, 360p, or a format ID

set -e

URL="$1"
QUALITY="${2:-best}"

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

# Handle quality shortcuts
case "$QUALITY" in
    "best")   FORMAT_SPEC="bestvideo+bestaudio/best" ;;
    "1080p")  FORMAT_SPEC="bestvideo[height<=1080]+bestaudio/best[height<=1080]" ;;
    "720p")   FORMAT_SPEC="bestvideo[height<=720]+bestaudio/best[height<=720]" ;;
    "480p")   FORMAT_SPEC="bestvideo[height<=480]+bestaudio/best[height<=480]" ;;
    "360p")   FORMAT_SPEC="bestvideo[height<=360]+bestaudio/best[height<=360]" ;;
    *)        FORMAT_SPEC="$QUALITY" ;;  # Use as format ID directly
esac

# Check if ffmpeg is available for merging
if command -v ffmpeg &> /dev/null; then
    MERGE_FORMAT="--merge-output-format mp4"
else
    echo "Note: ffmpeg not found, video format may vary"
    MERGE_FORMAT=""
fi

echo "Downloading video..."

# Download with title-based filename, sanitized for filesystem
$YTDLP -f "$FORMAT_SPEC" $MERGE_FORMAT \
    -o "%(title)s.%(ext)s" --restrict-filenames \
    --progress "$URL"

echo ""
echo "Download complete!"
