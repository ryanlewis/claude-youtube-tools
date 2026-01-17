# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Claude Code plugin that summarizes YouTube videos by extracting transcripts via yt-dlp and generating AI summaries. The plugin exposes a `/youtube-tools:summarize` slash command.

## Testing the Plugin

Run Claude Code with this plugin loaded:
```bash
claude --plugin-dir /path/to/claude-youtube-tools
```

Then test with:
```
/youtube-tools:summarize https://www.youtube.com/watch?v=VIDEO_ID
```

Test the transcript fetcher directly:
```bash
bash scripts/fetch-transcript.sh "https://www.youtube.com/watch?v=VIDEO_ID"
```

## Architecture

```
.claude-plugin/
  plugin.json              # Plugin manifest (name, version, metadata)

commands/
  summarize.md             # Skill definition with YAML frontmatter
                           # Uses $ARGUMENTS for user input, $CLAUDE_PLUGIN_ROOT for paths

scripts/
  fetch-transcript.sh      # Bash script that fetches transcripts via yt-dlp
                           # Auto-installs yt-dlp if missing (tries uvx, pipx, brew, winget, scoop)
                           # Parses VTT/SRT subtitles into clean text
```

## Key Implementation Details

- The command parses user input to separate the YouTube URL from custom styling instructions
- Transcript fetching tries multiple subtitle sources: manual English (human-created), auto-generated English, then any language
- VTT/SRT parsing strips timestamps, cue numbers, HTML tags, and deduplicates lines
- The skill has `allowed-tools: [Bash]` in frontmatter to permit running the fetch script
- URL validation requires standard YouTube formats: youtube.com/watch?v=ID, youtu.be/ID, youtube.com/shorts/ID, or m.youtube.com
