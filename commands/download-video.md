---
description: Download a YouTube video
argument-hint: <youtube-url>
allowed-tools: [Bash, AskUserQuestion]
---

Download the YouTube video. The user's input is: $ARGUMENTS

**Step 1: Parse the URL**

Extract the YouTube URL from the input (starts with `http`).

**Step 2: List available formats**

Run the format lister to see available qualities:
```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/list-formats.sh "URL_HERE"
```

**Step 3: Ask user for quality**

Use `AskUserQuestion` to let the user choose their preferred quality. Offer these options based on what's available:
- Best quality (recommended)
- 1080p
- 720p
- 480p

**Step 4: Download the video**

Once the user selects a quality, download with:
```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/download-video.sh "URL_HERE" "QUALITY"
```

Where QUALITY is one of: `best`, `1080p`, `720p`, `480p`, `360p`

**Step 5: Report result**

Tell the user where the file was saved (filename is based on video title).
