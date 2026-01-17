---
description: Summarize a YouTube video from its transcript
argument-hint: <youtube-url> [custom instructions]
allowed-tools: [Bash]
---

Summarize the YouTube video. The user's input is: $ARGUMENTS

**Step 1: Parse the input**

Extract the YouTube URL from the input (starts with `http`). Any additional text is custom instructions for how to format or style the summary.

Examples:
- `https://youtu.be/xxx` → URL only, use default summary style
- `https://youtu.be/xxx in bullet points` → URL + instruction to use bullets
- `in pirate speak https://youtu.be/xxx` → URL + instruction to write like a pirate

**Step 2: Fetch the transcript**

Run the transcript fetcher with ONLY the URL (not the custom instructions):
```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/fetch-transcript.sh "URL_HERE"
```

**Step 3: Summarize**

Based on the transcript:

1. If successful, provide a summary that:
   - Covers the main topic and purpose of the video
   - Highlights key points, arguments, or information
   - Notes any conclusions or takeaways
   - **Applies any custom instructions** the user provided (format, style, language, etc.)

2. If the fetch failed (ERROR message):
   - Explain what went wrong
   - Suggest trying a different video or checking if captions are enabled

Default style (if no custom instructions): Brief 2-3 paragraph overview, concise and informative.
