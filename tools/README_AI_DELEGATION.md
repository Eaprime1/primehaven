# AI Delegation System

Multi-AI orchestration tools for parallel task execution with Gemini, Perplexity, and Claude.

## Overview

The AI Delegation System enables you to delegate tasks to different AI assistants based on their strengths, monitor progress, and orchestrate complex multi-stage workflows.

### Available AI Assistants

| AI | Best For | Use Cases |
|----|----------|-----------|
| **Gemini** | Code generation, testing, rapid iteration | Implementation, test creation, code refactoring |
| **Perplexity** | Research, latest information (2026) | Technology research, best practices, documentation |
| **Claude** | Orchestration, integration, review | Code review, architecture, system integration |

## Tools

### 1. `ai_delegate.sh` - Task Delegation

Delegate a single task to an AI assistant.

**Usage:**
```bash
ai_delegate.sh <ai_type> "<task_description>" <output_file>
```

**Examples:**
```bash
# Research with Perplexity
ai_delegate.sh perplexity "Research OAuth 2.1 security best practices" oauth_research.md

# Implement with Gemini
ai_delegate.sh gemini "Create test suite for auth.ts" auth_tests.md

# Review with Claude (when needed in future)
ai_delegate.sh claude "Review authentication implementation" review.md
```

### 2. `ai_delegation_status.sh` - Monitor Tasks

Check status of all delegated tasks.

**Usage:**
```bash
ai_delegation_status.sh
```

**Output:**
- Active tasks with AI assignments
- Completion status
- Output file locations

### 3. `ai_delegation_retrieve.sh` - Retrieve Results

Retrieve and archive completed task results.

**Usage:**
```bash
ai_delegation_retrieve.sh <output_file>
```

**Example:**
```bash
ai_delegation_retrieve.sh oauth_research.md
```

### 4. `ai_delegation_menu.sh` - Interactive Interface

Interactive menu for creating, monitoring, and retrieving delegated tasks.

**Usage:**
```bash
ai_delegation_menu.sh
```

**Features:**
- 📝 Create new delegations with guided prompts
- 📋 View active delegations with status
- 📥 Retrieve completed tasks
- 📊 Real-time status dashboard

### 5. `ai_pipeline.sh` - Multi-AI Orchestration

Execute complex workflows with multiple AI assistants in sequence or parallel.

**Usage:**
```bash
# Quick 3-stage pipeline (Research → Implement → Review)
ai_pipeline.sh quick "Add user authentication"

# Create custom pipeline
ai_pipeline.sh create my_pipeline

# Run pipeline
ai_pipeline.sh run my_pipeline

# Check status
ai_pipeline.sh status my_pipeline

# List all pipelines
ai_pipeline.sh list
```

## Workflow Examples

### Example 1: Quick Feature Implementation

```bash
# One command to research, implement, and review
ai_pipeline.sh quick "OAuth 2.1 implementation"

# Pipeline automatically:
# 1. Perplexity researches best practices → oauth_research.md
# 2. Gemini implements based on research → oauth_implementation.md
# 3. Claude reviews and integrates → oauth_review.md
```

### Example 2: Parallel Research + Implementation

```bash
# Create pipeline
ai_pipeline.sh create auth_feature

# Edit ~/.ai_delegation/pipelines/auth_feature.pipeline:
STAGE_1_AI=perplexity
STAGE_1_TASK=Research OAuth 2.1 security best practices
STAGE_1_OUTPUT=oauth_research.md
STAGE_1_DEPENDS=

STAGE_2_AI=perplexity
STAGE_2_TASK=Research session management strategies
STAGE_2_OUTPUT=session_research.md
STAGE_2_DEPENDS=

STAGE_3_AI=gemini
STAGE_3_TASK=Implement OAuth 2.1 authentication
STAGE_3_OUTPUT=oauth_code.md
STAGE_3_DEPENDS=1,2

# Run pipeline (stages 1 and 2 execute in parallel)
ai_pipeline.sh run auth_feature
```

### Example 3: Manual Delegation Workflow

```bash
# Step 1: Research (Perplexity)
ai_delegate.sh perplexity "Research GraphQL best practices for 2026" graphql_research.md

# Step 2: Continue working on other tasks...

# Step 3: Check status
ai_delegation_status.sh

# Step 4: When complete, retrieve results
ai_delegation_retrieve.sh graphql_research.md

# Step 5: Use research for next step
ai_delegate.sh gemini "Implement GraphQL API based on research" graphql_api.md
```

## Architecture

### Directory Structure

```
~/.ai_delegation/
├── active/                 # Active delegations
│   ├── task_xyz.task      # Task metadata
│   └── ...
├── completed/             # Archived results
│   ├── oauth_research.md
│   └── ...
├── pipelines/             # Pipeline configurations
│   ├── auth_feature.pipeline
│   └── ...
└── pipeline_results/      # Pipeline outputs
    ├── oauth_research.md
    └── ...
```

### Task Metadata Format

Each task creates a `.task` file with:
```bash
AI_TYPE=perplexity
TASK_DESC=Research OAuth 2.1 best practices
OUTPUT_FILE=/path/to/output.md
START_TIME=2026-02-08 21:30:00
STATUS=active
```

### Pipeline Configuration Format

```bash
# Stage 1
STAGE_1_AI=perplexity
STAGE_1_TASK=Research task
STAGE_1_OUTPUT=research.md
STAGE_1_DEPENDS=          # No dependencies

# Stage 2 (depends on stage 1)
STAGE_2_AI=gemini
STAGE_2_TASK=Implement based on research
STAGE_2_OUTPUT=implementation.md
STAGE_2_DEPENDS=1         # Wait for stage 1

# Stages 3 and 4 (run in parallel, both depend on stage 2)
STAGE_3_AI=gemini
STAGE_3_TASK=Create tests
STAGE_3_OUTPUT=tests.md
STAGE_3_DEPENDS=2

STAGE_4_AI=perplexity
STAGE_4_TASK=Security audit
STAGE_4_OUTPUT=security.md
STAGE_4_DEPENDS=2
```

## Integration with Paradise Launcher

These tools will be integrated into Paradise under the "AI CLI & Delegation" category:

```bash
# From Paradise menu:
12) AI CLI & Delegation
    a) Gemini CLI Interactive
    b) Perplexity CLI Interactive
    c) AI Delegation Menu
    d) Create Pipeline
    e) Monitor Delegations
```

## Best Practices

### 1. Choose the Right AI

- **Perplexity**: Latest information, research, documentation
- **Gemini**: Code implementation, test generation, refactoring
- **Claude**: Complex integration, architecture, code review

### 2. Pipeline Design

- Start with research (Perplexity)
- Implement in parallel when possible (Gemini)
- End with integration and review (Claude)

### 3. Task Descriptions

Be specific and provide context:
```bash
# Good
ai_delegate.sh perplexity "Research OAuth 2.1 best practices for Node.js applications in 2026, focusing on security and JWT handling" research.md

# Less effective
ai_delegate.sh perplexity "OAuth info" output.md
```

### 4. Output Files

Use descriptive names with context:
```bash
oauth_research_2026.md       # Good: Clear purpose and date
session_mgmt_patterns.md     # Good: Specific topic
implementation_tests.md      # Good: Clear content type
output.md                    # Bad: Generic name
```

## Troubleshooting

### Task Not Completing

```bash
# Check task status
ai_delegation_status.sh

# Check AI tool availability
which gemini    # Should show /usr/local/bin/gemini
which llm       # Should show ~/.local/bin/llm (for Perplexity)
```

### Pipeline Stuck

```bash
# Check pipeline status
ai_pipeline.sh status my_pipeline

# Check for dependency issues - ensure all dependency stages completed
# Edit pipeline file to fix dependencies if needed
vim ~/.ai_delegation/pipelines/my_pipeline.pipeline
```

### Output File Not Found

```bash
# Check delegation directory
ls -la ~/.ai_delegation/active/
ls -la ~/.ai_delegation/completed/

# Verify output file path in task metadata
cat ~/.ai_delegation/active/*.task
```

## Future Enhancements

- [ ] Web dashboard for monitoring (BrowserOS integration)
- [ ] Slack/Discord notifications on completion
- [ ] Pipeline templates library
- [ ] Cost tracking per AI
- [ ] Automatic retry on failure
- [ ] Pipeline visualization
- [ ] Integration with git workflows (auto-commit results)
- [ ] Hodie archive integration

## Related Documentation

- [Multi-AI Delegation Design](../docs/MULTI_AI_DELEGATION_DESIGN.md)
- [Paradise Wrapper Integration](../docs/PARADISE_WRAPPER_INTEGRATION.md)
- [AI Consortium Architecture](../docs/AI_CONSORTIUM_ARCHITECTURE.md)

---

**Status**: Phase 2 Complete - Interactive delegation menus and pipeline orchestration ready
**Next**: Service wrapper implementation (Notion, Vercel, Sentry, PostHog)
