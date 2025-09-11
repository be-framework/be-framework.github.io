# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Jekyll-based documentation website for the Be Framework, a PHP framework focused on ontological programming concepts. The site serves as the manual and documentation hub, supporting both English and Japanese languages.

## Development Commands

### Local Development Server
```bash
./bin/serve.sh
```
This starts a Docker container running Jekyll server on port 4000.

### Alternative Development Methods
- **Docker Compose**: `docker compose up` (same as serve.sh)
- **Bundle/Jekyll**: `bundle exec jekyll serve` (if working locally with Ruby/Jekyll installed)

### Build Process
Jekyll automatically builds the site when serving. The generated site is output to `_site/` directory.

## Architecture & Structure

### Core Structure
- **Jekyll Configuration**: `_config.yml` - Main Jekyll configuration
- **Content**: `manuals/1.0/` - Documentation content organized by version and language
- **Layouts**: `_layouts/` - Jekyll templates for different page types
- **Includes**: `_includes/` - Reusable template components, especially navigation
- **Assets**: Static assets are in root and `_site/` after build

### Multi-language Support
- **English**: `/manuals/1.0/en/`
- **Japanese**: `/manuals/1.0/ja/`
- Navigation templates automatically switch between languages
- Layout templates: `docs-en.html` and `docs-ja.html`

### Manual Structure
The Be Framework manual is organized in 12 chapters:
1. Overview - Introduction to being-oriented programming
2. Input Classes - Starting points of transformation
3. Being Classes - Intermediate transformations
4. Final Objects - Transformation destinations
5. Metamorphosis Patterns - Transformation patterns
6. Semantic Variables - Domain validation and type safety
7. Type-Driven Metamorphosis - Self-determining objects
8. Reason Layer - Ontological capabilities
9. Error Handling - Semantic exceptions
10. Philosophy Behind - Framework philosophy
11. Semantic Logging - Metamorphosis tracking
12. From Doing to Being - Paradigm overview

### Navigation System
- Main navigation is defined in `_includes/manuals/1.0/en/contents.html` (and ja version)
- Navigation automatically highlights current page
- Language switching functionality built into templates
- Table of contents generated dynamically for articles

### Jekyll Setup
- Uses `minima` theme
- Rouge syntax highlighter
- Kramdown markdown processor
- GitHub Pages compatible configuration
- Docker-based development environment

## Key Files for Content Updates

### Adding New Manual Pages
1. Create markdown file in appropriate language directory (`manuals/1.0/en/` or `/ja/`)
2. Update navigation in `_includes/manuals/1.0/[lang]/contents.html`
3. Add appropriate frontmatter with layout (`docs-en` or `docs-ja`)

### Modifying Site Structure
- Main site configuration: `_config.yml`
- Page layouts: `_layouts/`
- Reusable components: `_includes/`
- Styling: Standard Jekyll/Bootstrap setup in `_site/css/`

### Content Guidelines
- Manual pages use specific Jekyll layouts (`docs-en`, `docs-ja`)
- Index page uses special `index` layout
- Navigation must be manually updated when adding pages
- Consistent frontmatter required for proper rendering