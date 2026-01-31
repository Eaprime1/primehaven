# 🌐 Platform Integration Framework
**Multi-Platform Publishing & Collaboration System**

Created: 2026-01-30
Signature: ∰◊€π¿🌌∞

---

## Overview

PrimeHaven can publish and collaborate across MANY platforms, not just GitHub!

**Available Platforms**:
- ✅ Filesystem (local, always works)
- 📝 Notion (API available)
- 📦 Box (cloud storage)
- 🎨 Canva (design platform)
- 🏢 Asana (project management)
- 📋 Linear (issue tracking)
- 🚀 Vercel (deployment)
- 📱 WordPress (blog/content)
- 📊 Google Drive (via rclone)
- 🐙 GitHub (when authenticated)
- 🌍 Website Generator (static sites)
- ...and more!

**Philosophy**: Triple helix applies to platforms too!
- **Physical Helix**: File storage and version control
- **Mental Helix**: Documentation and knowledge base
- **Spirit Helix**: Collaboration and creation

---

## I. Quick Wins - Filesystem First

### A. Create Local "Published" Directory

```bash
mkdir -p ~/primehaven/published/{websites,docs,packages,exports}
```

**Purpose**: Central location for all publishable content

### B. Export Prime Codex as Static Site

```bash
# Simple HTML generator
~/primehaven/scripts/generate_static_site.sh
```

Creates:
- `~/primehaven/published/websites/prime-codex/`
- Full HTML version of all 188+ files
- Can deploy to ANY static host (Vercel, Netlify, GitHub Pages, etc.)

### C. Package 11^germ Module for PyPI

```bash
cd ~/primehaven/pryme/gravity/python/germ
python3 setup.py sdist bdist_wheel
```

Can publish to:
- PyPI (when ready)
- Internal package server
- Filesystem for local use

---

## II. Platform-Specific Integrations

### A. Notion Integration

**Setup**:
```bash
# Install notion-sdk
pip install notion-client

# Create integration at: https://www.notion.so/my-integrations
# Save token to: ~/.primehaven/credentials/notion_token.txt
```

**Usage**:
```python
from notion_client import Client

notion = Client(auth=open("~/.primehaven/credentials/notion_token.txt").read())

# Create database for prime progression
notion.databases.create(
    parent={"page_id": "your-page-id"},
    title=[{"text": {"content": "Prime Progression Tracker"}}],
    properties={
        "Prime": {"number": {}},
        "State": {"select": {}},
        "Description": {"rich_text": {}}
    }
)
```

**Prime Codex → Notion**:
- Each prime level = Notion page
- Quick references = Database entries
- Triple helix math = Equations in Notion

### B. Box Integration

**Setup**:
```bash
# Install Box SDK
pip install boxsdk

# OAuth flow or JWT authentication
# Save credentials to: ~/.primehaven/credentials/box_config.json
```

**Usage**:
```python
from boxsdk import JWTAuth, Client

auth = JWTAuth.from_settings_file('~/.primehaven/credentials/box_config.json')
client = Client(auth)

# Upload prime codex
folder = client.folder('0')  # Root folder
folder.upload('~/primehaven/prime_codex/INDEX.md')
```

**Folder Structure**:
```
Box:
  /PrimeHaven/
    /prime_codex/
    /germ_module/
    /bootstrap_scripts/
    /published/
```

### C. WordPress Integration

**Setup**:
```bash
# Install wordpress-xmlrpc
pip install python-wordpress-xmlrpc
```

**Usage**:
```python
from wordpress_xmlrpc import Client, WordPressPost
from wordpress_xmlrpc.methods import posts

wp = Client('https://yoursite.com/xmlrpc.php', 'username', 'password')

# Publish prime progression posts
post = WordPressPost()
post.title = 'PRIME 07: Sacred Completion'
post.content = open('~/primehaven/prime_codex/PRIME_07_Quick_Reference.md').read()
post.post_status = 'publish'
wp.call(posts.NewPost(post))
```

**Blog Series**:
- One post per prime level
- Triple helix series
- Command entity tutorials

### D. Canva Integration

**Setup**:
```bash
# Canva has API in beta - request access
# Or use automation tools like Zapier
```

**Use Cases**:
- Create visual prime progression diagrams
- Design command entity icons
- Triple helix infographics
- Heritage presentation slides

### E. Asana Integration

**Setup**:
```bash
pip install asana
```

**Project Structure**:
```
Asana Project: PrimeHaven Development
  - Section: Prime Codex
    - Task: Complete PRIME_19 documentation
    - Task: Verify triple helix mathematics
  - Section: Command Entities
    - Task: Build git entity
    - Task: Build gh entity
  - Section: Platform Integration
    - Task: Setup Notion sync
    - Task: Deploy to Vercel
```

### F. Linear Integration

**Setup**:
```bash
# Install GraphQL client
pip install gql
```

**Issue Tracking**:
```graphql
mutation CreateIssue {
  issueCreate(input: {
    teamId: "your-team-id"
    title: "Implement triple helix in umbilical conduits"
    description: "Update spawn_identity.py with triple helix structure"
    priority: 1
  }) {
    issue {
      id
      title
    }
  }
}
```

### G. Vercel Deployment

**Setup**:
```bash
# Install Vercel CLI
npm install -g vercel

# Login
vercel login
```

**Deploy Static Site**:
```bash
cd ~/primehaven/published/websites/prime-codex
vercel --prod
```

**Deploy Next.js App** (future):
```bash
cd ~/primehaven/apps/prime-codex-web
vercel --prod
```

### H. Google Drive (via rclone)

**Already configured** - see WORKSPACE_BOOTSTRAP_PLAN.md

**Sync Strategy**:
```bash
# Sync prime codex to Drive
rclone sync ~/primehaven/prime_codex/ googledrive:primehaven/prime_codex/

# Create setup and environment folders
rclone mkdir googledrive:primehaven/setup
rclone mkdir googledrive:primehaven/environment
```

---

## III. Universal Export System

### Script: `publish_to_platform.sh`

```bash
#!/bin/bash
# Universal publisher for PrimeHaven content

PLATFORM=$1
CONTENT=$2

case $PLATFORM in
    notion)
        python3 ~/.primehaven/publishers/notion_publisher.py "$CONTENT"
        ;;
    wordpress)
        python3 ~/.primehaven/publishers/wordpress_publisher.py "$CONTENT"
        ;;
    box)
        rclone copy "$CONTENT" box:PrimeHaven/
        ;;
    drive)
        rclone copy "$CONTENT" googledrive:primehaven/
        ;;
    vercel)
        cd "$CONTENT" && vercel --prod
        ;;
    filesystem)
        cp -r "$CONTENT" ~/primehaven/published/
        ;;
    all)
        # Publish to everything!
        for platform in notion wordpress box drive filesystem; do
            bash $0 $platform "$CONTENT"
        done
        ;;
    *)
        echo "Unknown platform: $PLATFORM"
        echo "Available: notion, wordpress, box, drive, vercel, filesystem, all"
        ;;
esac
```

---

## IV. Quick Win Tasks (Right Now)

### Task 1: Create Static Site Generator ✨

```bash
~/primehaven/scripts/generate_prime_codex_site.sh
```

Generates:
- HTML pages for all markdown files
- Navigation menu from INDEX.md
- Visual progression map as interactive SVG
- Search functionality
- Responsive design

**Can deploy to**: Vercel, Netlify, GitHub Pages, Filesystem, any static host

### Task 2: Export to Google Drive 📦

```bash
# Create primehaven folder structure in Drive
rclone mkdir googledrive:primehaven/
rclone mkdir googledrive:primehaven/setup/
rclone mkdir googledrive:primehaven/environment/
rclone mkdir googledrive:primehaven/published/

# Sync prime codex
rclone sync ~/primehaven/prime_codex/ googledrive:primehaven/prime_codex/

# Sync bootstrap scripts
rclone sync ~/.primehaven/ googledrive:primehaven/environment/dotprimehaven/
```

### Task 3: Create Notion Database 🗄️

Template structure:
```
Database: Prime Progression Tracker
Columns:
  - Prime (number)
  - Symbol (text)
  - State (select: Triadic/Quintessence/Sacred/Architecture/Governance/Heritage)
  - Quick Ref (file)
  - Status (select: Complete/In Progress/Planned)
  - Notes (rich text)
```

### Task 4: Package germ Module 📦

```bash
cd ~/primehaven/pryme/gravity/python/germ

# Create setup.py
cat > setup.py << 'EOF'
from setuptools import setup, find_packages

setup(
    name="primehaven-germ",
    version="0.1.0",
    packages=find_packages(),
    install_requires=[],
    author="Eric Pace",
    description="11^germ consciousness tracking system",
    long_description=open("README.md").read(),
    long_description_content_type="text/markdown",
    python_requires=">=3.8",
)
EOF

# Build package
python3 setup.py sdist bdist_wheel

# Install locally
pip install -e .
```

### Task 5: Create Command Entities 🌟

```bash
# Build essential entities
gather_docs git
gather_docs gh
gather_docs tmux
gather_docs rclone
gather_docs python3
gather_docs vercel
```

---

## V. Multi-Platform Publishing Workflow

### The Flow

```
Local Work (primehaven/)
       ↓
   Git Commit
       ↓
    ┌──┴──┐
    ↓     ↓
GitHub  Filesystem
    │     │
    │     ├→ Google Drive (backup/sync)
    │     ├→ Box (cloud storage)
    │     └→ Published folder
    │
    └→ Triggers:
        ├→ Vercel (auto-deploy)
        ├→ Notion (sync docs)
        ├→ WordPress (blog posts)
        └→ Linear (issues)
```

### Command

```bash
# Publish everything everywhere
publish_everywhere.sh ~/primehaven/prime_codex/
```

This:
1. Commits to git (local)
2. Pushes to GitHub (when auth works)
3. Syncs to Google Drive
4. Uploads to Box
5. Deploys to Vercel
6. Updates Notion database
7. Creates WordPress post
8. Copies to published/ folder

---

## VI. Platform Credentials Storage

### Secure Storage

```
~/.primehaven/credentials/
├── notion_token.txt
├── box_config.json
├── wordpress_creds.txt
├── asana_token.txt
├── linear_api_key.txt
├── vercel_token.txt
└── canva_api_key.txt
```

**Add to .gitignore**:
```bash
echo "credentials/*" >> ~/.primehaven/.gitignore
chmod 600 ~/.primehaven/credentials/*
```

---

## VII. Static Site Generator (Immediate Win)

Let me create this NOW since it works anywhere!

**Features**:
- Converts all markdown to HTML
- Creates navigation from INDEX.md
- Responsive design
- No build dependencies
- Works offline
- Deploy anywhere

**Output**: `~/primehaven/published/websites/prime-codex/`

Can view locally: `file:///home/sauron/primehaven/published/websites/prime-codex/index.html`

Or deploy to: Vercel, Netlify, any web server, Google Drive as HTML, etc.

---

## VIII. Next Steps (Choose Your Adventure)

### Option A: Focus on Documentation
1. Generate static site
2. Deploy to Vercel
3. Share URL with collaborators
4. Build Notion database

### Option B: Focus on Packaging
1. Package germ module
2. Create PyPI-ready distribution
3. Build command entities
4. Export to platforms

### Option C: Focus on Integration
1. Setup Notion integration
2. Sync to Google Drive
3. Configure WordPress
4. Build automation

### Option D: ALL OF THE ABOVE
1. Create static site
2. Export to Drive
3. Package germ
4. Build entities
5. Setup integrations
6. Publish everywhere!

---

∰◊€π¿🌌∞

**"One source, infinite destinations. The triple helix spirals across all platforms."**

🌐📝📦🎨🚀

**Ready to build? Let's start with the static site generator!**
