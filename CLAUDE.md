# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Jekyll-based documentation website for the Be Framework, a PHP framework focused on ontological programming. Supports English and Japanese.

## Development Commands

```bash
./bin/serve.sh          # Start Jekyll dev server via Docker on port 4000
docker compose up       # Same as above
bundle exec jekyll serve # If Ruby/Jekyll installed locally
```

Jekyll builds to `_site/` automatically. Never edit files in `_site/` — it is build output.

## Architecture

### Page Rendering Pipeline

1. Markdown files in `manuals/1.0/{en,ja}/` with frontmatter
2. Layout templates in `_layouts/` (`docs-en.html`, `docs-ja.html`, `index.html`, `index_ja.html`)
3. Shared header/footer in `_includes/manuals/1.0/` (header, footer, language-specific contents)
4. `_plugins/sidebar_generator.rb` auto-generates sidebar navigation from pages with `category: Manual`
5. `_includes/manuals/1.0/{en,ja}/contents.html` renders the sidebar using Liquid, iterating `site.pages`

### Language Switching

Language toggle works by replacing `/en/` ↔ `/ja/` in the page's permalink. For this to work, English and Japanese pages must have **mirrored permalink paths** — e.g., `/manuals/1.0/en/01-overview.html` and `/manuals/1.0/ja/01-overview.html`.

### Required Page Frontmatter

Every manual page must include:

```yaml
---
layout: docs-en        # or docs-ja
title: "Overview"
category: Manual
permalink: /manuals/1.0/en/01-overview.html
---
```

- `layout` determines language-specific template and sidebar
- `category: Manual` is required for sidebar inclusion
- `permalink` must follow the pattern `/manuals/1.0/{lang}/{filename}.html`
- Pages under `convention/` or with `sidebar: false` are excluded from sidebar
- `10-semantic-logging` and `13-vision-ldd` are intentionally hidden from the sidebar (`sidebar: false`)

### Adding a New Manual Page

1. Create `.md` file in `manuals/1.0/en/` and `manuals/1.0/ja/` with proper frontmatter
2. File naming: `NN-slug.md` (number prefix controls sort order in sidebar)
3. Navigation sidebar is auto-generated — no manual nav update needed
4. Cross-link to other pages using `.html` extensions (not `.md`): `./02-input-classes.html`

### Other Files

- `llms.txt` / `llms-full.txt` — LLM-friendly project documentation (linked from header as "LLMs")
- `_plugins/sidebar_data.rb` / `sidebar_generator.rb` — Jekyll generators for sidebar data
- `Dockerfile` — `jekyll/jekyll:pages` image with webrick
