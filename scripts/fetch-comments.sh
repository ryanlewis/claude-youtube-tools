#!/bin/bash
# Fetch comments from a YouTube video for sentiment analysis
# Usage: fetch-comments.sh <youtube-url>
# Fetches top 100 comments sorted by popularity

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

echo "Fetching video info and comments (this may take a moment)..."
echo ""

# Fetch video metadata and comments as JSON
# --write-comments is required to include comments in the JSON output
# --extractor-args limits comments and sorts by popularity
$YTDLP --skip-download --write-comments \
    --extractor-args "youtube:max_comments=100,comment_sort=top" \
    --dump-json "$URL" 2>/dev/null | \
    python3 -c "
import sys
import json

data = json.load(sys.stdin)

print('=== VIDEO INFO ===')
print(f\"Title: {data.get('title', 'Unknown')}\")
print(f\"Channel: {data.get('channel', 'Unknown')}\")
print(f\"Views: {data.get('view_count', 'Unknown'):,}\" if isinstance(data.get('view_count'), int) else f\"Views: {data.get('view_count', 'Unknown')}\")
print(f\"Likes: {data.get('like_count', 'Unknown'):,}\" if isinstance(data.get('like_count'), int) else f\"Likes: {data.get('like_count', 'Unknown')}\")
print()

comments = data.get('comments', [])
if not comments:
    print('No comments found for this video.')
    sys.exit(0)

print(f'=== TOP COMMENTS ({len(comments)} fetched) ===')
print()

for i, comment in enumerate(comments[:100], 1):
    author = comment.get('author', 'Unknown')
    text = comment.get('text', '').replace('\n', ' ')[:500]  # Truncate long comments
    likes = comment.get('like_count', 0)

    print(f'{i}. [{likes} likes] @{author}')
    print(f'   {text}')
    print()
"
