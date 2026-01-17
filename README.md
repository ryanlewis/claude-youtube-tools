# YouTube Tools Plugin for Claude Code

A Claude Code plugin for working with YouTube videos - summarize content, download videos/audio, and analyze comment sentiment.

## Features

- **Summarize videos**: Extract transcripts and generate AI-powered summaries with custom styling
- **Download videos**: Save videos in your preferred quality (best, 1080p, 720p, 480p)
- **Download audio**: Extract audio as MP3 with embedded cover art
- **Comment analysis**: Fetch top comments and get AI-generated sentiment analysis
- Auto-installs yt-dlp if not present

## Installation

### From My Plugin Marketplace

Install from [my Claude Code plugin marketplace](https://github.com/ryanlewis/claude-plugins):

```
/plugin install youtube-tools@github.com/ryanlewis/claude-plugins
```

### Local Development

```bash
claude --plugin-dir /path/to/claude-youtube-tools
```

## Usage

### Summarize a Video

```
/youtube-tools:summarize <youtube-url> [custom instructions]
```

**Examples:**
```
/youtube-tools:summarize https://www.youtube.com/watch?v=dQw4w9WgXcQ
/youtube-tools:summarize https://youtu.be/dQw4w9WgXcQ in bullet points
/youtube-tools:summarize https://youtu.be/dQw4w9WgXcQ as if explaining to a 5 year old
```

### Download Video

```
/youtube-tools:download-video <youtube-url>
```

Downloads a YouTube video to the current directory. You'll be prompted to select a quality (best, 1080p, 720p, 480p).

**Example:**
```
/youtube-tools:download-video https://www.youtube.com/watch?v=dQw4w9WgXcQ
```

### Download Audio

```
/youtube-tools:download-audio <youtube-url>
```

Extracts audio from a YouTube video and saves it as MP3 with the video thumbnail as cover art. Falls back to native format (m4a/webm) if ffmpeg is not installed.

**Example:**
```
/youtube-tools:download-audio https://www.youtube.com/watch?v=dQw4w9WgXcQ
```

### Comment Sentiment Analysis

```
/youtube-tools:comments <youtube-url>
```

Fetches the top 100 comments from a video and provides AI-generated sentiment analysis including:
- Overall sentiment (positive/negative/mixed)
- Common themes and topics
- Notable/representative comments
- Engagement quality assessment

**Example:**
```
/youtube-tools:comments https://www.youtube.com/watch?v=dQw4w9WgXcQ
```

## How It Works

1. You provide a YouTube URL and optional instructions
2. The plugin uses yt-dlp to fetch transcripts, download media, or retrieve comments
3. Claude processes the data and provides summaries, analysis, or saves files to disk

## Prerequisites

- One of: uv, pipx, brew (macOS/Linux), winget or scoop (Windows)
- Internet connection

The plugin will run yt-dlp via uvx/pipx, or auto-install via brew/winget/scoop.

## Limitations

- **Summarize**: Only works with videos that have transcripts/subtitles available
- **Download**: Single videos only (no playlist support)
- **Audio**: MP3 conversion requires ffmpeg (falls back to native format otherwise)
- **Comments**: Only fetches top 100 comments; videos with disabled comments will fail

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

### Audio saved as m4a/webm instead of MP3

Install ffmpeg to enable MP3 conversion:
```bash
# macOS
brew install ffmpeg

# Ubuntu/Debian
sudo apt install ffmpeg

# Windows (winget)
winget install ffmpeg

# Windows (scoop)
scoop install ffmpeg
```

### "Comments are disabled" or no comments found

The video has comments disabled by the uploader. This cannot be bypassed.

## License

MIT
