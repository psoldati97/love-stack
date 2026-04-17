---
name: brand-voice
description: Lock in a consistent brand voice, style, and tone across all written content. Analyze existing content to extract voice rules, then apply those rules to new writing.
allowed-tools: ["Read", "Glob", "Grep", "Write"]
version: 1.0.0
author: On Deck Society
---

# Brand Voice

When activated, help the user maintain a consistent brand voice across their writing. Works in two modes: voice extraction and voice application.

## Mode 1: Voice Extraction

When the user provides existing content (blog posts, marketing copy, social posts, emails, a style guide), extract the brand voice rules:

- Sentence length patterns (short and punchy, long and lyrical, mixed)
- Punctuation habits (heavy em dash use, no em dashes, frequent parenthetical asides, declarative periods)
- Vocabulary preferences (colloquial vs formal, industry jargon tolerance, specific words they use or avoid)
- Tonal range (irreverent, earnest, authoritative, conspiratorial, warm)
- Structural patterns (how paragraphs open, how they close, use of lists vs prose)
- Signature phrases or linguistic quirks
- Taboos (words, phrases, or styles the brand never uses)

Output a structured voice profile the user can save as a reference doc.

## Mode 2: Voice Application

When the user asks to write new content "in our brand voice" or "like the rest of our copy":

1. Check if a voice profile exists in the project (look for voice.md, brand-voice.md, tone-of-voice.md, or similar in the project root or /docs)
2. If found, apply those rules to the new content
3. If not found, ask the user to either point to reference content or run voice extraction first

When writing in-voice content, produce a draft that actively mirrors the extracted patterns. Flag any place where the voice feels forced or where the content's requirements conflict with the voice.

## When to Invoke

Invoke when the user says: "match our brand voice", "write this in our tone", "make this sound like us", "extract our voice from these posts", "does this sound like our brand", or similar.
