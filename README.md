# YouTube Summarizer Plugin

A Claude Code plugin that summarizes YouTube videos by extracting transcripts and providing AI-generated overviews.

## Features

- Extract transcripts/subtitles from YouTube videos using yt-dlp
- Generate concise summaries of video content
- Support for custom instructions (bullet points, different styles, languages, etc.)
- Auto-installs yt-dlp if not present

## Installation

### Local Development

```bash
claude --plugin-dir /path/to/claude-youtube-tools
```

## Usage

```
/youtube-tools:summarize <youtube-url> [custom instructions]
```

### Examples

Basic summary:
```
/youtube-tools:summarize https://www.youtube.com/watch?v=dQw4w9WgXcQ
```

With custom instructions:
```
/youtube-tools:summarize https://youtu.be/dQw4w9WgXcQ in bullet points
/youtube-tools:summarize https://youtu.be/dQw4w9WgXcQ as if explaining to a 5 year old
/youtube-tools:summarize https://youtu.be/dQw4w9WgXcQ in formal academic language
/youtube-tools:summarize in pirate speak https://youtu.be/dQw4w9WgXcQ
/youtube-tools:summarize give me bullet points for https://youtu.be/dQw4w9WgXcQ
```

## How It Works

1. You provide a YouTube URL and optional instructions
2. The plugin extracts the video transcript using yt-dlp
3. Claude analyzes the transcript and generates a summary
4. If you provided custom instructions, the summary follows your requested style

## Prerequisites

- One of: uv, pipx, brew (macOS/Linux), winget or scoop (Windows)
- Internet connection

The plugin will run yt-dlp via uvx/pipx, or auto-install via brew/winget/scoop.

## Limitations

- Only works with videos that have transcripts/subtitles available
- Single videos only (no playlist support)
- Summary quality depends on transcript accuracy
- Videos without captions cannot be summarized

## Troubleshooting

### "No transcript/subtitles available"

The video doesn't have captions enabled. Try a different video that has subtitles.

### "Failed to install yt-dlp"

Install yt-dlp manually:
```bash
# Using uv (recommended)
uv tool install yt-dlp

# Using pipx
pipx install yt-dlp

# Using pip
pip install --user yt-dlp

# Using brew (macOS)
brew install yt-dlp

# Using winget (Windows)
winget install yt-dlp

# Using scoop (Windows)
scoop install yt-dlp
```

### "URL does not appear to be a valid YouTube URL"

Make sure you're using a full YouTube URL:
- `https://www.youtube.com/watch?v=VIDEO_ID`
- `https://youtu.be/VIDEO_ID`
- `https://www.youtube.com/shorts/VIDEO_ID`

## License

MIT
