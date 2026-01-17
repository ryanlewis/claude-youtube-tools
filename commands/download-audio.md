---
description: Download audio from a YouTube video as MP3
argument-hint: <youtube-url>
allowed-tools: [Bash]
---

Download audio from the YouTube video. The user's input is: $ARGUMENTS

**Step 1: Parse the URL**

Extract the YouTube URL from the input (starts with `http`).

**Step 2: Download the audio**

Run the audio downloader:
```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/download-audio.sh "URL_HERE"
```

This will:
- Extract audio and convert to MP3 (if ffmpeg is available)
- Embed the video thumbnail as cover art
- Save with a filename based on the video title
- Fall back to native format (m4a/webm) if ffmpeg is not installed

**Step 3: Report result**

Tell the user where the audio file was saved.
