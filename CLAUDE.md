# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a frontend-based automatic navigation project (前端自动导航项目) that dynamically generates navigation cards for all pages by reading a JSON configuration file. The project is built with vanilla HTML, CSS, and JavaScript, focusing on simplicity and security.

## Core Architecture

### Configuration-Driven Design
- **pages.json**: Central configuration file that defines all pages in the project
  - Each page entry includes: title, description, file path, image/CSS class, and category
  - The index.html reads this file and automatically generates navigation cards
  - Categories enable filtering functionality on the homepage

### Page Structure
- **index.html**: Main homepage that auto-generates navigation cards from pages.json
- **Individual HTML pages**: Self-contained pages (checkin-reminder.html, log.html, etc.)
- **CSS-generated images**: Uses pure CSS to create images instead of external files (css/generated-images.css)

### Server Setup
- **server.js**: Simple Node.js HTTP server for local development
  - Default route (/) redirects to checkin-reminder.html
  - Serves static files with appropriate MIME types
  - Default port: 8000 (configurable via PORT environment variable)

## Development Commands

### Running the Development Server
```bash
node server.js
```
Access at: http://localhost:8000/

### Adding New Pages

**Method 1: Manual (Recommended for single pages)**
1. Create your HTML file in the project root
2. Add entry to pages.json:
```json
{
    "title": "Page Title",
    "description": "Page description",
    "file": "your-page.html",
    "imageType": "css",
    "imageClass": "css-image-butterfly",
    "category": "Your Category"
}
```

**Method 2: Automated (For bulk additions)**
- Linux/Mac: Run `./add-pages.sh` (requires jq: `sudo apt-get install jq`)
- Windows: Run `.\add-pages.ps1` in PowerShell
- Script automatically extracts titles, generates descriptions, and assigns CSS images

## Key Features

### Security Implementation
All HTML pages should include these security headers:
```html
<meta http-equiv="Content-Security-Policy" content="default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline' https://cdnjs.cloudflare.com;">
<meta http-equiv="X-XSS-Protection" content="1; mode=block">
<meta http-equiv="X-Frame-Options" content="DENY">
<meta http-equiv="X-Content-Type-Options" content="nosniff">
```

JavaScript in index.html uses `escapeHtml()` function to prevent XSS attacks when rendering page data.

### CSS-Generated Images
- Located in: css/generated-images.css
- Available classes: css-image-butterfly, css-image-sunset, css-image-landscape, css-image-cat, css-image-rabbit, css-image-add-page, css-image-tech-style
- Benefits: Faster loading (no HTTP requests), scalable, customizable
- See CSS-IMAGES-GUIDE.md for full documentation

### Category Filtering
- Pages can be grouped by category in pages.json
- Homepage automatically generates filter buttons
- Common categories: "Host工具", "站点信息"

## Important Files

- **pages.json**: Master configuration - all pages must be registered here
- **index.html**: Homepage with auto-generation logic
- **server.js**: Development server
- **css/generated-images.css**: CSS image definitions
- **SHELL-SCRIPT-GUIDE.md**: Documentation for automation scripts
- **CSS-IMAGES-GUIDE.md**: Documentation for CSS image system

## Application-Specific Pages

### checkin-reminder.html
- Daily check-in task management system
- Features: Add/edit/delete tasks, mark completion, collapse completed tasks
- Uses localStorage for data persistence
- Includes quick input cards for weather, mood, and work tasks

### log.html
- Timeline-based development log
- Calendar component for date navigation
- Integration with Memos API for cloud backup
- Local folder backup/restore functionality
- Uses Tailwind CSS and Font Awesome

### md_to_mindmap.html
- Markdown to mindmap converter
- Parses markdown structure into visual mindmaps

## Code Patterns

### Adding Pages to Navigation
When creating new functionality pages:
1. Build self-contained HTML file with inline styles/scripts
2. Include security meta tags
3. Add "返回主页" (back to home) button linking to index.html
4. Register in pages.json with appropriate category
5. Use CSS images when possible (imageType: "css")

### Data Persistence
- Use localStorage for client-side data storage
- Key naming convention: descriptive names (e.g., "checkinTasks", "memosToken")
- Always parse/stringify JSON when storing objects

### Responsive Design
- Use Bootstrap 4 (via CDN) or Tailwind CSS
- Mobile-first approach with viewport meta tag
- Test on multiple screen sizes

## Browser Compatibility
- Target: Chrome 60+, Firefox 55+, Safari 12+, Edge 79+
- Use modern ES6+ JavaScript features
- CSS Grid and Flexbox for layouts

## Notes
- Project uses Chinese language (zh-CN) for UI
- No build process required - pure static files
- Bootstrap 4 and other libraries loaded via CDN
- Backup mechanism: Scripts create .bak files before modifying pages.json
