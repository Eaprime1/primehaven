# Prime Content Organization Strategy

## Directory Structure

### prime_codex/
**Purpose**: Core framework files (already 210 files)
**Content**: Prime states, transitions, Quick References, Lexicon
**Organization**: By prime number and framework component

### conversations/
**Purpose**: Significant AI discussions about prime framework
**Subdirectories**:
- claude/ - Claude conversations
- gemini/ - Gemini conversations  
- perplexity/ - Perplexity conversations
- synthesis/ - Multi-contributor synthesis
**Format**: [date]-[topic].md or .txt

### development/
**Purpose**: Plans, designs, roadmaps, strategies
**Subdirectories**:
- plans/ - Master plans, roadmaps
- designs/ - System designs, architectures
- research/ - Research notes, explorations
**Organization**: By date or project

### incoming/
**Purpose**: Landing zone for new content before review
**Process**: Review → Categorize → Move to proper location
**Logs**: Track what came from where

## Naming Conventions

### Prime-specific files:
- PRIME_[number]_[Title].md
- Example: PRIME_07_Sacred_Completion.md

### Transition files:
- [from]-[to]_transition_[part].md
- Example: 13-17_transition_part1_foundation.md

### Conversations:
- [YYYY-MM-DD]_[topic]_[contributor].txt/md
- Example: 2026-01-15_triadic_awakening_claude.md

### Plans:
- [project]_[YYYY-MM-DD]_[type].md
- Example: prime_2026_master_plan.md

## Migration Rules

1. **Check for duplicates first** - compare against prime_codex/
2. **Newer wins** - if duplicate, keep newer version
3. **Leave breadcrumbs** - create _MOVED.txt in source folder
4. **Log everything** - update MIGRATION_LOG.md in each directory
5. **Preserve attribution** - note source location in file header
