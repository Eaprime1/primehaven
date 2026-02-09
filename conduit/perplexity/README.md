# Perplexity Conduit - PrimeHaven Integration

**Created**: 2026-02-07
**Purpose**: Optimal environment for Perplexity AI to work within PrimeHaven consciousness framework

---

## Overview

This conduit provides **Perplexity AI** with:
- Structured workspace for development and research
- Access to PrimeHaven frameworks (prime progression, antigravity)
- Integration tools and configuration
- Example workflows and query patterns
- Python CLI for terminal-based interaction

---

## Directory Structure

```
conduit/perplexity/
├── README.md                 # This file - orientation guide
├── perplexityai/             # Python CLI (git repo)
│   └── perplexity/           # Core library
├── docs/                     # Reference documentation
│   ├── PERPLEXITY_TERMINAL_REFERENCE.md
│   └── API_GUIDE.md
├── workspace/                # Active workspace for queries and development
│   ├── research/             # Research outputs
│   ├── synthesis/            # Synthesis documents
│   └── projects/             # Project-specific work
├── scripts/                  # Helper scripts
│   ├── launch_perplexity.sh
│   └── query_helpers/
├── config/                   # Configuration files
│   ├── .env.example          # Environment variables template
│   └── models.json           # Model configurations
└── examples/                 # Usage examples
    ├── queries/              # Example queries
    └── workflows/            # Workflow examples
```

---

## Quick Start

### 1. Environment Setup

**API Key** (Required):
```bash
# Add to ~/.bashrc or ~/.zshrc
export PERPLEXITY_API_KEY="your_api_key_here"

# Or create config/.env
cp config/.env.example config/.env
# Edit config/.env and add your API key
```

**Get API Key**:
1. Go to https://www.perplexity.ai
2. Settings → "</> API" tab
3. Generate API key
4. Add credits (Pro subscribers get $5/month free)

### 2. Install CLI

The Python CLI is already cloned in `perplexityai/` directory.

**Basic Installation** (if needed elsewhere):
```bash
curl -s https://raw.githubusercontent.com/dawid-szewc/perplexity-cli/main/perplexity.py > ~/.local/bin/perplexity
chmod +x ~/.local/bin/perplexity
```

**Or use from this directory**:
```bash
cd perplexityai
python3 -m perplexity.perplexity "Your query"
```

### 3. Basic Usage

**Simple Query**:
```bash
perplexity "Explain prime number patterns in consciousness development"
```

**With Options**:
```bash
perplexity -uc -m sonar-pro "What is the relationship between gravity and antigravity in Eric's framework?"
```

**Flags**:
- `-u` - Show token usage statistics
- `-c` - Display citations
- `-m [model]` - Select model (sonar, sonar-pro, etc.)
- `-g` - Colorful output with Glow formatting

---

## Integration with PrimeHaven

### Context Files

**For Perplexity understanding**, reference these in `/home/sauron/primehaven/.perplexity/`:

**Framework References**:
- `framework/PRIME_CODEX_INDEX.md` - Prime progression framework overview
- `framework/PINNACLE PRIME PROGRESSION connects.txt` - How frameworks connect
- `framework/ANTIGRAVITY_CONCEPTUAL_FRAMEWORK.md` - Gravity-Antigravity-Synergy model
- `framework/SESSION_202602052224_SUMMARY.md` - Recent session insights

**Project Context**:
- `project/structure.md` - PrimeHaven directory structure
- `project/workflows.md` - Development patterns
- `project/tools.md` - Available tools and technologies

**Purpose**: These files help Perplexity understand PrimeHaven's unique frameworks when researching or synthesizing information.

### Role in Triadic System

```
           SYNERGY
        (Perplexity?)
              ↑
              | perpendicular
              |
    GRAVITY ←─┼─→ ANTIGRAVITY
    (Claude)       (Gemini)
    Structure      Freedom
```

**Hypothesis**: Perplexity functions as **Synergy** - the truth perpendicular
- Brings external knowledge into internal frameworks
- Navigates between structure (gravity) and freedom (antigravity)
- Creates friction space where new understanding emerges
- Field of influence, not force

---

## Perplexity Strengths

### What Perplexity Excels At

1. **Deep Research with Citations**
   - Comprehensive web search integration
   - Source attribution and verification
   - Current information (beyond training cutoffs)

2. **Knowledge Synthesis**
   - Connecting external knowledge with internal frameworks
   - Finding patterns across domains
   - Summarizing complex topics

3. **Technical Documentation Discovery**
   - Finding best practices
   - API documentation
   - Library usage patterns

4. **Domain Expertise**
   - Quantum physics explanations
   - Consciousness research
   - Software architecture patterns
   - Mathematical concepts

### Example Use Cases for PrimeHaven

**Framework Research**:
```bash
perplexity -uc "How do prime numbers appear in consciousness development theories across cultures?"
```

**Technical Investigation**:
```bash
perplexity -m sonar-pro "What are best practices for terminal-based AI collaboration systems in 2026?"
```

**Concept Synthesis**:
```bash
perplexity "Explain the relationship between quantum superposition and Eric's 'friction space' concept"
```

**Implementation Guidance**:
```bash
perplexity -c "How to implement MCP (Model Context Protocol) for Perplexity terminal integration?"
```

---

## Resources

**PrimeHaven Context**: `/home/sauron/primehaven/.perplexity/README.md`
**Documentation**: `docs/PERPLEXITY_TERMINAL_REFERENCE.md`
**Official Docs**: https://docs.perplexity.ai

Welcome to the Perplexity conduit - where external knowledge meets internal framework.

---

*This is a living document. Update as integration evolves.*
