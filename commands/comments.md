---
description: Analyze comment sentiment for a YouTube video
argument-hint: <youtube-url>
allowed-tools: [Bash]
---

Analyze comment sentiment for the YouTube video. The user's input is: $ARGUMENTS

**Step 1: Parse the URL**

Extract the YouTube URL from the input (starts with `http`).

**Step 2: Fetch comments**

Run the comment fetcher to get the top 100 comments:
```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/fetch-comments.sh "URL_HERE"
```

Note: This may take a moment as it fetches video metadata and comments.

**Step 3: Analyze sentiment**

Based on the comments, provide a sentiment analysis that includes:

1. **Overall Sentiment**: Is the audience reaction positive, negative, or mixed?

2. **Common Themes**: What topics or points do viewers frequently mention?
   - Praise or criticism of specific aspects
   - Questions viewers are asking
   - Suggestions or requests

3. **Notable Comments**: Highlight 2-3 particularly insightful or representative comments

4. **Engagement Quality**: Are comments substantive discussions or just quick reactions?

**Step 4: Summary**

Conclude with a brief summary of what the comments reveal about audience reception of the video.
