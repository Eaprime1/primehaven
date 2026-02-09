# Ecosystem Discovery - Integration Patterns & Connections

**Session**: 2026-02-08 19:40 onwards
**Purpose**: Map all tools/services, notice connections, document integration ideas
**Method**: Autonomous exploration with notes for later decision-making

---

## Tools Mentioned by Eric

### Project Management / Task Tracking
- [ ] **Asana** - Team project management
- [ ] **Linear** - Issue tracking, product development
- [ ] **Notion** - All-in-one workspace (AVAILABLE via MCP!)

### Development / Deployment
- [ ] **Vercel** - Deployment platform (AVAILABLE via skill!)
- [ ] **GitHub** - Code hosting (already integrated)

### Content / Web
- [ ] **WordPress** - Content management

### Storage / Cloud
- [ ] **Box** - Cloud storage
- [ ] **Google Drive** - Cloud storage (rclone configured)

### Communication / Collaboration
- [ ] **Anasa** - (Need to identify - might be Asana typo?)

### AI Platforms
- [x] **Claude Code** - Working
- [x] **Perplexity** (via llm) - Working
- [ ] **Gemini** - Broken (fixable)
- [ ] **ChatGPT** - Unknown
- [ ] **Grok3** - Unknown
- [ ] **Monica AI** - Not integrated
- [ ] **Merlin AI** - Not integrated

---

## Discovery Log

### Pass 1: System Scan

#### Installed CLI Tools (/usr/local/bin)
- ✅ **claude** - Claude Code CLI
- ✅ **gemini** - Gemini CLI (broken, needs Node upgrade)
- ✅ **expandrive** - Cloud drive mounter (for Box, Drive, etc.)
- ✅ **zapier** / **zapier-platform** - Automation platform
- ✅ **http-server** - Dev server
- ✅ **json-server** - Mock API server
- ✅ **ncu** / **npm-check-updates** - npm utilities

#### Available Skills (from system)
**Notion Integration**:
- Notion:create-database-row
- Notion:create-page
- Notion:create-task
- Notion:database-query
- Notion:find
- Notion:search
- Notion:tasks:build/plan/explain-diff/setup

**Vercel Integration**:
- vercel:deploy
- vercel:logs
- vercel:setup

**Stripe Integration**:
- stripe:explain-error
- stripe:test-cards

**Sentry Integration**:
- sentry:getIssues
- sentry:seer

**PostHog Integration**:
- posthog:actions/dashboards/docs/errors/experiments/flags/insights/etc.

**Pinecone Integration** (Vector DB):
- pinecone:assistant-chat/create/upload/sync
- pinecone:query
- Multiple MCP tools available

**Atlassian Integration**:
- atlassian:capture-tasks-from-meeting-notes
- atlassian:generate-status-report
- atlassian:search-company-knowledge
- atlassian:spec-to-backlog
- atlassian:triage-issue

**Figma Integration**:
- figma:code-connect-components
- figma:create-design-system-rules
- figma:implement-design

**HuggingFace Integration**:
- Multiple tools for model training, datasets, papers

**CodeRabbit**:
- coderabbit:review

#### MCP Servers Found
- google-drive-mcp (configured at ~/.config/google-drive-mcp)
- servers/ directory in ~/.primehaven/mcp/

#### APIs & Integrations Available
- **GitHub** - Already authenticated (token expired, but configured)
- **Google Drive** - rclone configured (gdrive_suxen)
- **Zapier** - CLI installed
- **ExpanDrive** - Can mount Box, Dropbox, etc.

---

## Connection Patterns Noticed

### Pattern 1: Project Management Cluster
**Tools**: Notion, Atlassian (Jira/Confluence), Asana, Linear
**Connections**:
- All handle tasks, projects, documentation
- Notion = Personal/team wiki + tasks
- Atlassian = Enterprise project management (Jira issues, Confluence docs)
- Asana = Team task management
- Linear = Product/engineering workflow

**Integration Opportunity**:
- Capture tasks from one, sync to others
- Unified task view across platforms
- "Meeting notes → Jira tasks" pattern already exists (Atlassian skill)
- Could extend to: "Meeting notes → distribute to Notion/Asana/Linear"

**Terminal Pattern**:
```bash
# Notion already has skills
notion:create-task "Task description"
notion:search "query"

# Pattern to replicate:
asana:create-task "Task description"
linear:create-issue "Issue description"
```

### Pattern 2: Development/Deployment Pipeline
**Tools**: GitHub, Vercel, CodeRabbit, Sentry, PostHog
**Connections**:
- GitHub = Code repository
- Vercel = Deployment platform
- CodeRabbit = AI code review
- Sentry = Error tracking
- PostHog = Analytics/feature flags

**Integration Opportunity**:
- Full DevOps pipeline in terminal
- Push code → Deploy to Vercel → Monitor with Sentry/PostHog
- CodeRabbit review before merge
- All from command line

**Terminal Pattern**:
```bash
# Code review
/coderabbit review

# Deploy
/vercel deploy

# Check errors
/sentry:getIssues

# Analytics
/posthog:insights
```

### Pattern 3: Content/Storage Cluster
**Tools**: WordPress, Box, Google Drive, Notion
**Connections**:
- WordPress = Published content
- Box/Drive = File storage
- Notion = Knowledge base

**Integration Opportunity**:
- Content pipeline: Draft in Notion → Publish to WordPress
- File sync: Box/Drive ↔ Local ↔ Git
- ExpanDrive can mount Box/Drive as local filesystem

**Terminal Pattern**:
```bash
# Mount cloud storage
expandrive mount box

# Sync to local
rclone sync box:/folder ~/primehaven/content/

# Process and publish
wordpress:publish content.md
```

### Pattern 4: AI Orchestration (Our Focus)
**Tools**: Claude, Gemini, Perplexity, ChatGPT, Grok, Monica, Merlin
**Connections**:
- Each AI has different strengths
- Paradise launcher coordinates
- GitHub as shared state
- Terminal as interface

**Integration Opportunity**:
- Multi-AI consultation on complex tasks
- Parallel processing of independent work
- AI-to-AI handoffs (Claude generates → Perplexity researches → Gemini iterates)

### Pattern 5: Automation Layer
**Tools**: Zapier, GitHub Actions, Vercel Functions
**Connections**:
- Zapier = Cross-app automation
- GitHub Actions = Git-triggered automation
- Vercel Functions = Serverless compute

**Integration Opportunity**:
- Zapier CLI to create/manage automations from terminal
- Link GitHub events → Notion updates
- Link Sentry errors → Jira issues
- All programmatically managed

---

## Ideas & Observations

### Idea 1: Universal Task Interface
Create single command that works across all PM tools:
```bash
task create "Do the thing" --system notion
task create "Do the thing" --system asana
task create "Do the thing" --system linear
task create "Do the thing" --system all  # Create in all systems
```

### Idea 2: Content Pipeline Automation
```bash
# Draft in Notion
notion:create-page "Article Title"

# When ready, publish
wordpress:publish --notion-page "Article Title"

# Automatically:
# - Exports from Notion
# - Converts formatting
# - Publishes to WordPress
# - Updates Notion with published URL
```

### Idea 3: DevOps Dashboard in Terminal
```bash
devops status
# Shows:
# - GitHub: Latest commits, open PRs
# - Vercel: Deployment status
# - Sentry: Error count (last 24h)
# - PostHog: Active users
# - All in one terminal view
```

### Idea 4: AI Research Pipeline
```bash
research "quantum consciousness patterns"
# Executes:
# 1. Perplexity: External research with citations
# 2. Claude: Synthesize with internal frameworks
# 3. Notion: Create research page with findings
# 4. GitHub: Commit research notes
```

### Idea 5: Meeting → Action Automation
```bash
meeting-notes process meeting_2026-02-08.md
# Uses Atlassian skill pattern:
# 1. Extract action items
# 2. Create tasks in Notion/Asana/Jira
# 3. Assign to people
# 4. Set due dates
# 5. Link to meeting notes
```

---

## Tool Status Matrix

| Tool | Installed | Working | Terminal CLI | Skill Available | Integration Priority |
|------|-----------|---------|--------------|-----------------|---------------------|
| Claude | ✅ | ✅ | ✅ | ✅ | Complete |
| Perplexity | ✅ | ✅ | ✅ (llm) | ❌ | Add skill wrapper |
| Gemini | ✅ | ❌ | ✅ | ❌ | Fix Node, add skill |
| ChatGPT | ❓ | ❓ | ❓ | ❌ | Investigate |
| Grok | ❓ | ❓ | ❓ | ❌ | Investigate |
| Notion | ❌ | ✅ | ❌ | ✅ | Add CLI wrapper |
| Vercel | ❌ | ❌ | ❌ | ✅ | Install CLI |
| GitHub | ✅ | ⚠️ | ✅ | ✅ | Fix token |
| Zapier | ✅ | ❓ | ✅ | ❌ | Test & integrate |
| Sentry | ❌ | ✅ | ❌ | ✅ | Add CLI wrapper |
| PostHog | ❌ | ✅ | ❌ | ✅ | Add CLI wrapper |
| Atlassian | ❌ | ✅ | ❌ | ✅ | Add CLI wrapper |
| Figma | ❌ | ✅ | ❌ | ✅ | Add CLI wrapper |
| WordPress | ❌ | ❓ | ❓ | ❌ | Investigate |
| Box | ❌ | ⚠️ | ❌ (mount) | ❌ | ExpanDrive mount |
| Asana | ❌ | ❓ | ❓ | ❌ | Investigate |
| Linear | ❌ | ❓ | ❓ | ❌ | Investigate |

---

## Next Steps (Auto-prioritized)

### Tier 1: Fix What's Broken
1. Fix Gemini (Node.js upgrade) → Unblocks antigravity AI
2. Fix GitHub token → Unblocks pushing/collaboration
3. Verify ChatGPT/Grok existence

### Tier 2: Leverage Existing Skills
4. Create skill-based CLI wrappers for:
   - Notion (most complete skill set)
   - Vercel (deploy from terminal)
   - Atlassian (Jira/Confluence from terminal)
5. Test Zapier CLI functionality

### Tier 3: Research New Integrations
6. Investigate Asana API/CLI
7. Investigate Linear API/CLI
8. Investigate WordPress API (WP-CLI likely)
9. Test ExpanDrive for Box mounting

### Tier 4: Build Unified Interfaces
10. Create task management abstraction layer
11. Create DevOps dashboard
12. Create AI research pipeline
13. Extend AI Consortium with skill-based tools

---

## Architecture Insight: Skills vs CLIs

**Two patterns emerging**:

**Pattern A: Direct CLI** (Claude, Gemini, Perplexity)
- Standalone binary
- Direct execution
- Immediate response
- Example: `claude ask "question"`

**Pattern B: Skill-based** (Notion, Vercel, Sentry, etc.)
- Available through `/skillname` in Claude Code
- Programmatic access
- Rich integration
- Example: `/Notion:create-task "description"`

**Opportunity**: Create CLI wrappers that invoke skills
```bash
#!/bin/bash
# notion-cli wrapper
claude skill Notion:$1 "$2"
```

This bridges both patterns → Everything accessible from terminal.

---

---

## Critical Discovery: Node.js Cascade Effect

**Single fix unlocks multiple tools**:
- Gemini requires Node v20+
- Zapier requires Node v22+
- Current: Node v18.19.1

**Impact of Node.js upgrade to v22**:
✅ Fixes Gemini CLI
✅ Fixes Zapier CLI
✅ Enables full automation workflows
✅ Unblocks both AI antigravity AND automation layers

**This is the highest ROI action available.**

---

## Installed NPM Global Packages

```
@anthropic-ai/claude-code@2.1.25
@google/gemini-cli@0.23.0
@google/genai@1.34.0
http-server@14.1.1
json-server@1.0.0-beta.3
npm-check-updates@19.2.0
zapier-platform-cli@18.0.5
```

---

## Integration Roadmap (Prioritized by ROI)

### Phase 1: Foundation (High ROI, Low Effort)

**1.1 Node.js Upgrade** (CRITICAL)
- Unblocks: Gemini + Zapier
- Commands: 3 lines
- Time: 2 minutes
- Impact: Massive

**1.2 Notion CLI Wrapper**
- Skills already available
- Just needs wrapper script
- Time: 15 minutes
- Impact: Task management from terminal

**1.3 Vercel CLI Install + Wrapper**
- Skill available
- Install CLI + wrapper
- Time: 10 minutes
- Impact: Deploy from terminal

**1.4 GitHub Token Refresh**
- Enables push/pull
- Time: 5 minutes (with browser) or 10 (with lynx)
- Impact: Code collaboration restored

### Phase 2: DevOps Integration (Medium ROI, Medium Effort)

**2.1 Sentry CLI Wrapper**
- Skill available
- Create wrapper
- Time: 15 minutes
- Impact: Error monitoring from terminal

**2.2 PostHog CLI Wrapper**
- Skill available
- Create wrapper
- Time: 15 minutes
- Impact: Analytics from terminal

**2.3 DevOps Dashboard Script**
- Combines GitHub + Vercel + Sentry + PostHog
- Single command shows all status
- Time: 30 minutes
- Impact: Unified monitoring

### Phase 3: Project Management Integration (High Value, Higher Effort)

**3.1 Atlassian CLI Wrapper**
- Skills available (comprehensive)
- Create wrapper for Jira/Confluence
- Time: 20 minutes
- Impact: Enterprise PM from terminal

**3.2 Asana Integration**
- Research API
- Create CLI or use existing tool
- Time: 1-2 hours
- Impact: Team task management

**3.3 Linear Integration**
- Research API
- Create CLI or use existing tool
- Time: 1-2 hours
- Impact: Product/eng workflow

**3.4 Universal Task Interface**
- Abstraction layer across all PM tools
- Create tasks in any/all systems
- Time: 2-3 hours
- Impact: Massive - unified task management

### Phase 4: Content Pipeline (Medium Value, Medium Effort)

**4.1 WordPress CLI**
- Investigate WP-CLI
- Install if available
- Time: 30 minutes
- Impact: Content publishing

**4.2 Box Integration**
- ExpanDrive mounting
- Test and configure
- Time: 20 minutes
- Impact: Cloud storage access

**4.3 Content Pipeline Automation**
- Notion → WordPress
- Drive/Box → Local → Git
- Time: 2 hours
- Impact: Streamlined content workflow

### Phase 5: Advanced AI Orchestration (High Value, High Effort)

**5.1 AI Research Pipeline**
- Multi-AI coordination
- Perplexity → Claude → Notion
- Time: 1 hour
- Impact: Automated research

**5.2 AI Code Review Pipeline**
- CodeRabbit + Claude + Gemini
- Multiple perspectives on code
- Time: 1 hour
- Impact: Better code quality

**5.3 Paradise Full Integration**
- All tools in Paradise launcher
- Single-keypress access
- Time: 2-3 hours
- Impact: Complete unified interface

---

## Quick Wins Available Now

**Without any installation, just wrapper scripts**:

1. **Notion Terminal**
```bash
# notion-cli wrapper using skills
#!/bin/bash
case "$1" in
  create-task) echo "/Notion:create-task $2" ;;
  search) echo "/Notion:search $2" ;;
  # etc
esac
```

2. **DevOps Status**
```bash
# devops-status using skills
#!/bin/bash
echo "GitHub: $(gh pr list | wc -l) open PRs"
echo "Sentry: [use /sentry:getIssues skill]"
echo "PostHog: [use /posthog:insights skill]"
```

3. **Task Creator**
```bash
# task wrapper
#!/bin/bash
# Use /Notion:create-task skill
# Can extend to other systems later
```

---

## Pattern Recognition: The Skill Bridge

**Discovered**: Most advanced integrations are **skills**, not CLIs

**Pattern**:
```
Service → Skill Available → No CLI → Create CLI Wrapper
Example: Notion ✓        ✗           → notion-cli.sh
```

**Implementation**:
```bash
#!/bin/bash
# Generic skill-to-CLI bridge
SERVICE="$1"
ACTION="$2"
shift 2
ARGS="$@"

# Invoke Claude Code skill from command line
echo "/$SERVICE:$ACTION $ARGS" | claude-skill-executor
```

**Impact**: Turns 15+ skills into terminal commands immediately

---

**Status**: Major discoveries made, roadmap created
**Next**: Waiting for direction - fix Node.js or build wrappers first?

