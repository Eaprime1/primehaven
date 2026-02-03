# Framework Extractor

Automated triadic pattern extraction with Enhanced Markdown v2.0 tagging.

## Quick Start

```bash
# Extract from single document
framework-extractor --source document.md

# Process entire folder
framework-extractor --source ~/Documents/frameworks --batch

# Deep analysis with LLM (future)
framework-extractor --source document.docx --deep

# Interactive mode for review
framework-extractor --source document.md --interactive
```

## Features

- ✅ Parses docx, txt, md files
- ✅ Keyword-based pattern detection (fast)
- ✅ Explicit triad markers (Vector:, Anti-Vector:, Prime:)
- ✅ Known triadic patterns (Body/Mind/Soul, etc.)
- ✅ EM v2.0 tagging with metadata
- ✅ Confidence scoring (0.0-1.0)
- ✅ Auto-extraction for high confidence (≥0.8)
- ✅ Validation before saving
- ✅ Comprehensive reports
- 🚧 LLM deep analysis (planned)

## Output

Generates EM v2.0 tagged markdown:

```markdown
<!-- EM:v2.0 framework:triadic category:decision-space confidence:0.95 -->
<!-- source:document.md extracted:2026-02-02T16:30:00Z -->

# Framework: [Name]

## Vector: [Title]
[Content...]

## Anti-Vector: [Title]
[Content...]

## Prime: [Title]
[Content...]

∰◊€π¿
```

## Architecture

- `parser.py` - Document parsing (docx, txt, md)
- `detector.py` - Pattern detection (keyword + LLM future)
- `extractor.py` - EM v2.0 generation
- `scorer.py` - Confidence calculation
- `validator.py` - Quality validation
- `reporter.py` - Summary reports

## Usage Examples

### Basic Extraction
```bash
cd ~/primehaven
.bit/scripts/framework-extractor --source ~/Documents/my-framework.md
```

Output: `staged/frameworks/triadic/decision-spaces/my-framework.md`

### Batch Processing
```bash
# Process all docx files in Drive folder
.bit/scripts/framework-extractor \\
  --source ~/gdrive/€consortium® \\
  --batch \\
  --auto-threshold 0.9
```

### Interactive Review
```bash
# Prompt for medium-confidence patterns
.bit/scripts/framework-extractor \\
  --source document.md \\
  --interactive
```

## Confidence Levels

- **High (0.8-1.0)**: Auto-extracted
  - Explicit keywords found
  - All three parts substantial (>20 words)
  - Clear structure

- **Medium (0.5-0.8)**: Flagged for review
  - Implicit patterns
  - LLM detected (future)
  - Partial matches

- **Low (<0.5)**: Skipped
  - Weak patterns
  - Missing components
  - Use `--show-low` to see

## Workflow Integration

1. **Extract**: Run tool on documents
2. **Validate**: Review `staged/frameworks/`
3. **Promote**: Move validated to production
4. **Use**: Apply templates in projects

## Development Status

**Version**: 1.0.0 (Initial Release)

**Completed**:
- [x] Document parser
- [x] Keyword pattern detector
- [x] EM v2.0 extractor
- [x] Confidence scorer
- [x] Validator
- [x] Reporter
- [x] CLI interface

**Planned**:
- [ ] LLM deep analysis (--deep flag)
- [ ] Prime number association detection
- [ ] Category auto-classification
- [ ] Batch optimization
- [ ] Progress indicators

∰◊€π¿
