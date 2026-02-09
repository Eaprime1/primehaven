# Wrapper Requirements Review

**Created**: 2026-02-08 21:30
**Purpose**: Comprehensive review of available resources for creating skill-to-CLI wrappers
**Status**: Node.js fixed ✅ → Review phase → Ready for wrapper development

---

## Executive Summary

**Goal**: Create CLI wrappers for Claude Code skills to enable:
1. Direct terminal usage of integrations
2. Multi-AI delegation (Gemini + Perplexity can call same tools)
3. Git automation and archival workflows
4. Paradise launcher integration

**Available Resources**:
- ✅ 100+ Claude Code skills ready for wrapping
- ✅ Node.js v22.22.0 (modern runtime)
- ✅ Python 3.12.3 (stable)
- ✅ Docker 27.3.1 (containerization)
- ✅ Multi-AI delegation system (Phase 1 complete)
- ✅ 30+ external integrations mapped

---

## 1. Runtime Environments

### Node.js ✅
```
Version: v22.22.0
NPM: 10.9.4
Status: READY (just upgraded from v18)
Unlocked: Gemini CLI, Zapier CLI
```

**Capabilities**:
- Modern ES modules support
- Full async/await
- Latest language features
- Compatible with all MCP servers

### Python ✅
```
Version: 3.12.3
Status: READY
```

**Capabilities**:
- Type hints and modern syntax
- Async support (asyncio)
- Rich ecosystem for API clients
- Hugging Face integration ready

### Shell/Bash ✅
```
Shell: bash 5.x
Status: READY
```

**Capabilities**:
- Background process management
- File I/O and piping
- Git integration
- System automation

### Docker ✅
```
Version: 27.3.1
Status: READY
```

**Capabilities**:
- Isolated environments
- Reproducible builds
- Service orchestration
- Archive snapshots

---

## 2. Available AI Tools

### Claude (Current) ✅
```
Tool: claude (CLI)
Access: Direct
Skills: 100+ available
Integration: Native
```

### Gemini ✅
```
Tool: /usr/local/bin/gemini
Version: 0.23.0
Status: WORKING (after Node.js fix)
Usage: gemini ask "query"
```

### Perplexity ✅
```
Tool: llm -m sonar / sonar-pro
Location: ~/.local/bin/llm
Status: WORKING
Usage: llm -m sonar-pro "research query"
```

### Zapier ✅
```
Tool: /usr/local/bin/zapier
Version: 18.0.5
Status: WORKING (after Node.js fix)
Integration: Potential for workflow automation
```

### GitHub CLI ✅
```
Tool: /usr/bin/gh
Status: WORKING
Usage: Full GitHub automation
```

---

## 3. Available Skills (100+ Total)

### Tier 1: High-Value Wrappers (Immediate Priority)

#### Notion (9 skills)
```bash
# Available:
- create-database-row
- create-page
- create-task
- database-query
- find
- search
- tasks:build
- tasks:explain-diff
- tasks:plan
- tasks:setup

# Wrapper Pattern:
notion <command> [args]
notion create-task "Implement OAuth"
notion search "authentication"
notion query "Tasks Database"
```

**Dependencies**:
- Notion API key (MCP server configured)
- Node.js wrapper script
- JSON parsing for results

#### Vercel (3 skills)
```bash
# Available:
- deploy
- logs
- setup

# Wrapper Pattern:
vercel-cli deploy
vercel-cli logs --project primehaven
```

**Dependencies**:
- Vercel CLI (available via npm)
- Vercel API token
- Project configuration

#### Sentry (4 skills)
```bash
# Available:
- getIssues
- seer (natural language queries)
- sentry-code-review
- sentry-setup-* (monitoring, logging, metrics, tracing)

# Wrapper Pattern:
sentry issues --project primehaven
sentry ask "What are the top errors today?"
sentry review-pr 123
```

**Dependencies**:
- Sentry API token
- Project DSN
- Python or Node.js SDK

#### PostHog (12 skills)
```bash
# Available:
- actions, dashboards, docs, errors
- experiments, flags, insights
- llm-analytics, logs, query
- search, surveys, workspace

# Wrapper Pattern:
posthog query "Show user retention this week"
posthog flags list
posthog errors --last-24h
```

**Dependencies**:
- PostHog API key
- Project API host
- Python client library

#### Atlassian (5 skills)
```bash
# Available:
- capture-tasks-from-meeting-notes
- generate-status-report
- search-company-knowledge
- spec-to-backlog
- triage-issue

# Wrapper Pattern:
atlassian search "OAuth implementation"
atlassian create-tasks-from meeting-notes.md
atlassian triage "Error: Auth failed"
```

**Dependencies**:
- Jira API token
- Confluence API token
- Atlassian domain configuration

### Tier 2: Specialized Wrappers

#### Pinecone (11 skills)
- Vector database operations
- Assistant chat/context/create
- Document upload and sync
- Query operations

#### Figma (3 skills)
- code-connect-components
- create-design-system-rules
- implement-design

#### Stripe (2 skills)
- explain-error
- test-cards
- stripe-best-practices

#### Hugging Face (7 skills)
- CLI operations
- Datasets management
- Model training
- Jobs infrastructure
- Paper publishing
- Experiment tracking

### Tier 3: Development Tooling

#### Code Review
- code-review:code-review
- pr-review-toolkit:review-pr
- coderabbit:review

#### Git Operations
- commit-commands:commit
- commit-commands:commit-push-pr
- commit-commands:clean_gone

#### Feature Development
- feature-dev:feature-dev
- superpowers:* (20+ development skills)

---

## 4. Wrapper Implementation Patterns

### Pattern A: Simple Skill Bridge
```bash
#!/bin/bash
# Directly invoke Claude Code skill from terminal

SKILL_NAME="$1"
shift
ARGS="$@"

claude skill "$SKILL_NAME" "$ARGS"
```

### Pattern B: MCP Server Wrapper
```bash
#!/bin/bash
# Call MCP server directly without Claude

MCP_SERVER="notion"
COMMAND="$1"
shift

# Use MCP protocol to call server
mcp_call "$MCP_SERVER" "$COMMAND" "$@"
```

### Pattern C: API Client Wrapper
```bash
#!/usr/bin/env node
// Direct API client for services

const { NotionClient } = require('@notionhq/client');

async function main() {
  const notion = new NotionClient({ auth: process.env.NOTION_TOKEN });
  // Execute command
}
```

### Pattern D: Multi-AI Delegation
```bash
#!/bin/bash
# Delegate to best AI for task type

TASK="$1"
AI="${2:-auto}"

case "$AI" in
  auto)
    # Choose AI based on task type
    if [[ "$TASK" =~ research|latest|2026 ]]; then
      ai_delegate perplexity "$TASK"
    elif [[ "$TASK" =~ test|code|implementation ]]; then
      ai_delegate gemini "$TASK"
    else
      # Claude handles by default
      claude ask "$TASK"
    fi
    ;;
  *)
    ai_delegate "$AI" "$TASK"
    ;;
esac
```

---

## 5. Dependencies Required

### Node.js Packages
```json
{
  "dependencies": {
    "@notionhq/client": "^2.x",
    "@sentry/node": "^7.x",
    "posthog-node": "^3.x",
    "@vercel/cli": "latest",
    "jira-client": "^8.x",
    "commander": "^11.x",
    "dotenv": "^16.x"
  }
}
```

### Python Packages
```txt
requests
anthropic
notion-client
sentry-sdk
posthog
jira
atlassian-python-api
pinecone-client
huggingface-hub
```

### Environment Variables
```bash
# API Keys needed
NOTION_API_KEY=
VERCEL_TOKEN=
SENTRY_AUTH_TOKEN=
SENTRY_DSN=
POSTHOG_API_KEY=
POSTHOG_HOST=
JIRA_URL=
JIRA_TOKEN=
CONFLUENCE_URL=
CONFLUENCE_TOKEN=
PINECONE_API_KEY=
HF_TOKEN=
STRIPE_SECRET_KEY=
FIGMA_TOKEN=
```

---

## 6. Directory Structure for Wrappers

```
primehaven/
├── wrappers/               # New directory for CLI wrappers
│   ├── bin/               # Executable scripts
│   │   ├── notion
│   │   ├── vercel-cli
│   │   ├── sentry-cli
│   │   ├── posthog-cli
│   │   ├── atlassian
│   │   └── ai-auto       # Auto-delegating wrapper
│   ├── lib/               # Shared libraries
│   │   ├── notion/
│   │   ├── sentry/
│   │   └── common.sh
│   ├── config/            # Configuration templates
│   │   ├── .env.template
│   │   └── wrappers.conf
│   └── tests/             # Wrapper tests
├── conduit/               # Existing AI environments
│   ├── perplexity/
│   ├── gemini/           # To be created
│   └── unified/          # Shared resources
└── .ai_delegation/        # Delegation outputs
```

---

## 7. Git Automation Opportunities

### Archive Snapshots (Domos Level)
```bash
#!/bin/bash
# Create entity-specific or project-specific archive

ENTITY="$1"  # e.g., "notion", "sentry", "project-x"
ARCHIVE_DIR="$HOME/primehaven/archives/$ENTITY"

# Create snapshot
git archive --format=tar.gz \
  --prefix="$ENTITY-$(date +%Y%m%d)/" \
  HEAD > "$ARCHIVE_DIR/$ENTITY-$(date +%Y%m%d).tar.gz"

# Store metadata
git log -1 --format="%H %ai %s" > "$ARCHIVE_DIR/SNAPSHOT_INFO.txt"
```

### Automated Commit Hooks
```bash
# .git/hooks/post-commit
#!/bin/bash
# Auto-delegate documentation updates

if git diff-tree --no-commit-id --name-only HEAD | grep -q "\.ts$\|\.js$"; then
  # Code changed - delegate doc updates to Gemini
  ai_delegate gemini \
    "Update documentation for changed files: $(git diff-tree --no-commit-id --name-only HEAD)" \
    "docs/auto_update_$(date +%s).md"
fi
```

### Entity Isolation
```bash
# Create separate git worktrees for each entity
git worktree add ~/primehaven/entities/notion notion-integration
git worktree add ~/primehaven/entities/sentry sentry-integration

# Each entity gets isolated development space
```

---

## 8. Paradise Launcher Integration

### Discovered
```
Location: primal/pryme/gravity/bash/paradise_unified.sh (likely)
Purpose: Unified terminal interface coordination hub
Status: Needs verification
```

### Integration Pattern
```bash
# Paradise should orchestrate all wrappers
paradise notion create-task "Task"
paradise ai gemini "Question"
paradise archive create notion-snapshot
paradise sync all-services
```

---

## 9. Multi-AI Pro Plan Capabilities

### Gemini Pro
- Rapid iteration
- Test generation
- Code implementation
- Multi-round dialogue

### Perplexity Pro
- Deep research with citations
- Latest information (2026)
- Academic paper access
- Multi-source synthesis

### Delegation Strategy
```bash
# Research + Implementation pipeline
ai_delegate perplexity "Research OAuth 2.1 best practices" research.md
# Wait for completion
ai_delegate gemini "Implement OAuth based on research.md" implementation.ts
# Claude reviews and integrates
claude review implementation.ts research.md
```

---

## 10. Implementation Priorities

### Phase 1: Foundation (Week 1)
1. ✅ Multi-AI delegation system (COMPLETE)
2. Create wrapper directory structure
3. Implement Pattern A (simple skill bridge)
4. Test with Notion wrapper

### Phase 2: Core Integrations (Week 2)
1. Notion CLI wrapper
2. Vercel deployment wrapper
3. Sentry monitoring wrapper
4. PostHog analytics wrapper
5. Environment variable management

### Phase 3: Multi-AI Enhancement (Week 3)
1. Gemini environment (conduit/gemini)
2. Unified AI launcher (ai-auto)
3. Task routing logic
4. Result aggregation

### Phase 4: Git Automation (Week 4)
1. Archive snapshot system
2. Entity-specific worktrees
3. Automated commit hooks
4. Documentation sync

### Phase 5: Paradise Integration (Week 5)
1. Locate and analyze paradise launcher
2. Integrate all wrappers
3. Unified command interface
4. Cross-system orchestration

---

## 11. Immediate Next Steps

### Create Wrapper Infrastructure
```bash
mkdir -p ~/primehaven/wrappers/{bin,lib,config,tests}
```

### Start with Notion Wrapper (Highest ROI)
```bash
# Create ~/primehaven/wrappers/bin/notion
# Implement basic commands:
#   notion create-task
#   notion search
#   notion query
```

### Set Up Gemini Environment
```bash
mkdir -p ~/primehaven/conduit/gemini
# Mirror perplexity setup
# Add Gemini-specific config
```

### Test Multi-AI Delegation
```bash
# Real-world test:
ai_delegate perplexity "Research Notion API rate limits 2026" notion_limits.md
ai_delegate gemini "Create rate limit handler based on notion_limits.md" rate_limiter.ts
```

---

## 12. Tools Already in Content

Based on user message: "you will find we have created a ton of the stuff we need. in our content there might be helpful tools ready also"

### Known Locations to Explore
```
primal/               # 35GB, 392K files - likely has existing tools
primal/pryme/gravity/bash/  # Paradise launcher location
spaces/               # 79GB workspaces - may have per-project tools
BrowserOS/            # New directory - browser automation?
.perplexity/          # Already configured
conduit/              # AI environments
```

### Search Strategy
```bash
# Find existing wrappers
find ~/primehaven/primal -name "*wrapper*" -o -name "*cli*" 2>/dev/null

# Find paradise tools
ls ~/primehaven/primal/pryme/gravity/bash/

# Find API integration scripts
find ~/primehaven -name "*api*" -name "*.sh" 2>/dev/null
```

---

## 13. Resource Availability Matrix

| Component | Status | Version | Notes |
|-----------|--------|---------|-------|
| Node.js | ✅ Ready | v22.22.0 | Just upgraded |
| Python | ✅ Ready | 3.12.3 | Stable |
| Docker | ✅ Ready | 27.3.1 | For isolation |
| Gemini CLI | ✅ Working | 0.23.0 | After Node fix |
| Perplexity | ✅ Working | llm tool | Via sonar models |
| Zapier CLI | ✅ Working | 18.0.5 | After Node fix |
| GitHub CLI | ✅ Working | Latest | gh command |
| Notion Skills | ✅ Available | 9 skills | MCP ready |
| Vercel Skills | ✅ Available | 3 skills | Deployment ready |
| Sentry Skills | ✅ Available | 4 skills | Monitoring ready |
| PostHog Skills | ✅ Available | 12 skills | Analytics ready |
| Atlassian Skills | ✅ Available | 5 skills | Jira/Confluence |
| Delegation System | ✅ Complete | Phase 1 | ai_delegate working |

---

## 14. Critical Success Factors

### For Wrappers
1. ✅ Runtime environments stable
2. ✅ AI tools accessible
3. ✅ Skills catalog complete
4. 🔄 API credentials (need to gather)
5. 🔄 Directory structure (ready to create)

### For Multi-AI
1. ✅ Delegation system working
2. ✅ Gemini accessible
3. ✅ Perplexity accessible
4. 🔄 Gemini environment setup
5. 🔄 Routing logic implementation

### For Git Automation
1. ✅ Git hooks directory ready
2. ✅ Background process support
3. 🔄 Archive strategy design
4. 🔄 Entity isolation pattern
5. 🔄 Domos level implementation

---

## Conclusion

**System Status**: READY FOR WRAPPER DEVELOPMENT

**Confidence Level**: HIGH
- All runtime environments operational
- AI tools verified working
- Skills catalog complete
- Implementation patterns defined
- Directory structure planned

**Blockers**: NONE
- Node.js fixed ✅
- Dependencies identified ✅
- Patterns established ✅

**Recommendation**: Proceed with Phase 1 implementation
1. Create wrapper directory structure
2. Start with Notion CLI wrapper (9 skills, high value)
3. Set up Gemini environment parallel to Perplexity
4. Test multi-AI delegation with real tasks

**Timeline**: Ready to begin immediately
