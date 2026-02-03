# Framework Extractor Tool Design
## Automated Triadic Pattern Extraction from Documents

**Date**: 2026-02-02
**Status**: Approved for Implementation
**Purpose**: Extract triadic frameworks from Drive documents with EM v2.0 tagging

---

## Overview

The Framework Extractor automates extraction of triadic patterns from documents (docx, txt, md), tags them with Enhanced Markdown v2.0, and routes them to the GitHub staging area for validation and production use.

**Key Innovation**: Hybrid approach combining fast keyword matching with optional deep LLM analysis, plus confidence-based auto-extraction.

---

## Architecture

### Core Components

**1. Document Parser**
- Handles docx (unzip + XML parsing), txt, md files
- Extracts text content while preserving structure (headings, sections, paragraphs)
- Output: Structured document object with sections/paragraphs indexed

**2. Pattern Detector (Hybrid)**

**Fast Pass** - Keyword Scanner
- Searches for explicit triadic markers:
  - Direct labels: "Vector:", "Anti-Vector:", "Prime:"
  - Thesis/Antithesis/Synthesis patterns
  - Common triads: "Body/Mind/Soul", "Work/Play/Create", "Individual/Systemic/Emergent"
  - Numbered three-part lists: "1. X, 2. Y, 3. Z"
- Confidence: 0.9-1.0 (high confidence for explicit patterns)
- Speed: Very fast, no external API calls

**Deep Pass** - LLM Analysis (`--deep` flag)
- Reads unmarked sections for implicit triadic thinking
- Identifies three-part structures without explicit labels
- Detects vector/anti-vector/prime dynamics in unstructured text
- Confidence: 0.5-0.8 (medium confidence, needs human review)
- Speed: Slower, requires LLM API

**3. Framework Extractor**
- Takes detected patterns and generates EM v2.0 tagged markdown
- Creates unique framework names from content
- Calculates confidence scores
- Routes to staging area based on category
- Generates extraction metadata

---

## Command-Line Interface

```bash
# Basic extraction (keyword matching only)
framework-extractor --source "path/to/doc.docx" --output staged/frameworks/

# Deep extraction (with LLM analysis)
framework-extractor --source "path/to/doc.docx" --deep

# Batch mode (process entire folder)
framework-extractor --source "gdrive_suxen:€consortium®" --batch

# Interactive mode (prompt for each pattern)
framework-extractor --source "path/to/doc.docx" --interactive

# Hybrid: batch + deep + auto-extract high confidence
framework-extractor --source "gdrive_suxen:€consortium®" --batch --deep --auto-threshold 0.8

# Show low-confidence patterns (normally skipped)
framework-extractor --source "path/to/doc.docx" --show-low
```

**Flags**:
- `--source PATH` - Document or folder to process (required)
- `--output DIR` - Output directory (default: staged/frameworks/)
- `--deep` - Enable LLM deep analysis for implicit patterns
- `--batch` - Process all files in source folder
- `--interactive` - Prompt human for medium-confidence patterns
- `--auto-threshold N` - Auto-extract patterns ≥ N confidence (default: 0.8)
- `--show-low` - Show patterns below threshold (normally skipped)
- `--category CAT` - Force category (decision-space, reality-anchor, entity-signature)

---

## Extraction Workflow

**Step-by-Step Process**:

1. **Parse Document**
   - Load file (handle docx, txt, md formats)
   - Extract text with structure preservation
   - Build section tree (headings → paragraphs)

2. **Detect Patterns**
   - **Fast Pass**: Keyword scan for explicit triads
   - **Deep Pass** (if `--deep`): LLM analysis for implicit triads
   - Collect all detected patterns with locations

3. **Score Confidence**
   - High (0.8-1.0): Explicit keywords, all parts clear
   - Medium (0.5-0.8): Implicit structure, LLM detected
   - Low (<0.5): Weak patterns, incomplete

4. **Filter by Threshold**
   - ≥ threshold → Auto-extract
   - 0.5-0.8 → Prompt human (if `--interactive`)
   - < 0.5 → Skip (unless `--show-low`)

5. **Extract Frameworks**
   - Generate EM v2.0 tagged markdown
   - Create unique framework name
   - Add source metadata and confidence score

6. **Route to Staging**
   - Determine category (decision-space, reality-anchor, etc.)
   - Save to `staged/frameworks/[category]/[framework-name].md`

7. **Generate Report**
   - Summary of processed files
   - Count of extracted frameworks by confidence
   - Errors and warnings
   - Next steps for validation

---

## Confidence Scoring System

**High Confidence (0.8-1.0)** - Auto-extract
- ✓ Explicit triadic keywords found
- ✓ All three parts present and substantial (>50 words each)
- ✓ Clear separation between sections
- ✓ Known triadic patterns recognized

**Medium Confidence (0.5-0.8)** - Prompt human
- ⚠ Implicit three-part structure detected
- ⚠ LLM identifies triadic thinking without explicit labels
- ⚠ Two parts clear, third part ambiguous
- ⚠ Partial keyword matches

**Low Confidence (<0.5)** - Skip
- ✗ Vague three-part structure
- ✗ Missing key components
- ✗ Contradictory content
- ✗ LLM uncertain

**Scoring Algorithm**:
```python
base_score = 0.5

# Add for explicit markers
if has_keyword_markers: base_score += 0.3
if all_three_parts_present: base_score += 0.1
if substantial_content: base_score += 0.1

# LLM analysis (if --deep)
if llm_detected_triad: base_score += 0.2
if llm_high_confidence: base_score += 0.1

# Deduct for issues
if missing_parts: base_score -= 0.2
if ambiguous_structure: base_score -= 0.1

confidence = clamp(base_score, 0.0, 1.0)
```

---

## Data Structures

**Detected Framework Object**:

```python
{
    "name": "Complexity Navigation",
    "type": "triadic",
    "category": "decision-space",
    "confidence": 0.95,
    "source": {
        "file": "googledrive/€consortium®/complexity-nav.docx",
        "extracted": "2026-02-02T16:30:00Z",
        "extractor_version": "1.0",
        "mode": "keyword"  # or "llm-deep"
    },
    "parts": {
        "vector": {
            "title": "Simplification Urge",
            "content": "The temptation to reduce complexity...",
            "start_line": 42,
            "word_count": 156
        },
        "anti_vector": {
            "title": "Preservation Imperative",
            "content": "The recognition that some complexity...",
            "start_line": 87,
            "word_count": 178
        },
        "prime": {
            "title": "Navigation Without Reduction",
            "content": "The 13-prime skill of moving through...",
            "start_line": 134,
            "word_count": 203
        }
    },
    "em_tags": {
        "framework": "triadic",
        "category": "decision-space",
        "prime": 13,
        "confidence": 0.95
    },
    "metadata": {
        "needs_validation": false,  # auto-extracted
        "status": "extracted"
    }
}
```

---

## Output Format

**Generated EM v2.0 Markdown**:

```markdown
<!-- EM:v2.0 framework:triadic category:decision-space prime:13 confidence:0.95 -->
<!-- source:googledrive/€consortium®/complexity-nav.docx -->
<!-- extracted:2026-02-02T16:30:00Z -->
<!-- extractor:framework-extractor v1.0 mode:keyword -->

# Framework: Complexity Navigation

## Vector: Simplification Urge

The temptation to reduce complexity to manageable chunks. When faced with
overwhelming systems, the natural response is to break them down, categorize,
and simplify until they become tractable...

## Anti-Vector: Preservation Imperative

The recognition that some complexity must remain intact. Certain systems lose
their essential properties when simplified. The drive to preserve irreducible
complexity in the face of simplification pressure...

## Prime: Navigation Without Reduction

The 13-prime skill of moving through complexity without destroying it. Neither
simplifying away the essence nor being paralyzed by the whole. Finding paths
through intricate systems while respecting their nature...

---

## Metadata

- **Source**: complexity-nav.docx
- **Extracted**: 2026-02-02T16:30:00Z
- **Confidence**: 0.95 (High - Auto-extracted)
- **Method**: Keyword matching
- **Status**: Needs validation
- **Category**: Decision-space triadic framework
- **Prime Association**: 13 (Complexity navigation)

---

## Application Notes

[Space for human to add application context during validation]

---

∰◊€π¿
```

**File Naming**: `[framework-name-slugified].md`
Example: `complexity-navigation.md`

**Output Location**:
- `staged/frameworks/triadic/decision-spaces/complexity-navigation.md`

---

## Error Handling

**Parse Errors** - Document unreadable/corrupted
- Log error with file path
- Skip file, continue batch processing
- Report at end: "3 files failed to parse"

**No Patterns Found** - Document has no triadic content
- Silent skip in batch mode
- Notify in interactive: "No triadic patterns detected"
- Don't create output file

**Ambiguous Patterns** - Multiple possible interpretations
- Medium confidence score (0.5-0.7)
- Prompt human in interactive mode
- Flag for review in batch mode
- Save to `staged/frameworks/[category]/needs-review/`

**LLM Failures** - API timeout, rate limit, error
- Fall back to keyword-only mode
- Log warning: "LLM analysis failed, using keyword mode"
- Continue processing (degraded but functional)

**File Write Errors** - Can't write to staging area
- Fail fast with clear error message
- Don't lose extracted data (log to temp file)
- Exit cleanly with error code 1

---

## Validation System

**Pre-Save Validation**:

**Required Fields**
- ✓ Framework has a name
- ✓ All three triadic parts present
- ✓ Each part has substantial content (>20 words)
- ✓ Valid EM v2.0 tags generated
- ✓ Source metadata complete

**Quality Checks**
- ✓ No placeholder text like "[Content]" or "[TBD]"
- ✓ No duplicate frameworks (check by content similarity)
- ✓ Parts are distinct (not repeating same content)
- ✓ Confidence score within valid range (0.0-1.0)
- ✓ Valid category assignment

**Post-Extraction Report**:

```
Framework Extraction Report
===========================
Source: gdrive_suxen:€consortium®
Processed: 42 documents
Duration: 2m 34s

Results:
  ✓ 15 frameworks extracted (high confidence ≥0.8)
  ? 8 frameworks flagged for review (medium confidence 0.5-0.8)
  ✗ 3 documents failed to parse
  ○ 16 documents contained no triadic patterns

Breakdown by Category:
  decision-spaces/: 8 files
  reality-anchors/: 3 files
  entity-signatures/: 2 files

Prime Associations:
  13-complexity/: 4 frameworks
  17-heritage/: 2 frameworks

Output Locations:
  staged/frameworks/triadic/decision-spaces/: 8 files
  staged/frameworks/triadic/reality-anchors/: 3 files
  staged/frameworks/prime/13-complexity/: 4 files

Failed Files:
  - corrupted-doc.docx (parse error)
  - empty-file.txt (no content)
  - invalid-format.doc (unsupported format)

Next Steps:
  1. Review flagged frameworks in staged/frameworks/
  2. Validate high-confidence extractions
  3. Run: em-validator --confidence-threshold 0.8
  4. Promote validated to production
```

---

## Testing Strategy

**Unit Tests**

1. **Document Parser Tests**
   - Parse valid docx, txt, md files
   - Handle corrupted files gracefully
   - Preserve structure (headings, sections)

2. **Pattern Detector Tests**
   - Detect explicit triadic markers
   - Recognize common triadic patterns
   - Score confidence accurately
   - Handle ambiguous cases

3. **Framework Extractor Tests**
   - Generate valid EM v2.0 markdown
   - Create proper file names
   - Route to correct categories
   - Include all metadata

**Integration Tests**

1. **End-to-End Test**
   - Process sample Drive folder
   - Verify output files created
   - Check EM v2.0 tags valid
   - Validate confidence scores

2. **Batch Processing Test**
   - Process 10+ documents
   - Verify report accuracy
   - Check error handling
   - Confirm no data loss

**Test Documents**

Create sample docs with known patterns:
- `test-explicit-triad.md` - Clear Vector/Anti-Vector/Prime
- `test-implicit-triad.txt` - Unlabeled three-part structure
- `test-no-pattern.md` - No triadic content
- `test-ambiguous.docx` - Multiple possible triads
- `test-corrupted.docx` - Invalid file for error handling

---

## Implementation Notes

**Technology Stack**:
- Language: Python 3.x (for docx parsing, text processing)
- Document parsing: Built-in zipfile + xml.etree (docx), standard file I/O (txt, md)
- LLM integration: Anthropic Claude API (for --deep mode)
- Output: Standard markdown files

**Key Dependencies**:
- Python 3.8+
- xml.etree.ElementTree (built-in)
- zipfile (built-in)
- anthropic SDK (for --deep mode, optional)

**File Structure**:
```
~/primehaven/.bit/scripts/
├── framework-extractor           # Main executable
├── framework_extractor/          # Python package
│   ├── __init__.py
│   ├── parser.py                 # Document parsing
│   ├── detector.py               # Pattern detection
│   ├── extractor.py              # Framework extraction
│   ├── scorer.py                 # Confidence scoring
│   ├── validator.py              # Output validation
│   └── reporter.py               # Report generation
└── tests/
    ├── test_parser.py
    ├── test_detector.py
    └── test_extractor.py
```

---

## Success Metrics

**Extraction Quality**:
- 90%+ confidence scores accurate (validated by human review)
- <5% false positives (extracted non-triads)
- <10% false negatives (missed real triads)

**Performance**:
- Process 100 documents in <5 minutes (keyword mode)
- Process 100 documents in <30 minutes (deep mode)
- <1% parse failures

**Usability**:
- Zero configuration needed for basic use
- Clear error messages
- Helpful reports with next steps

---

## Future Enhancements

**Phase 2** (not in initial implementation):
- Auto-categorization using LLM
- Prime number association detection
- Entity signature recognition
- Cross-reference detection
- Template suggestion (which template fits this framework?)

**Phase 3** (automation):
- Scheduled extraction runs
- Auto-sync with Drive
- Notification on new frameworks found
- Integration with Notion databases

---

∰◊€π¿

**Status**: Ready for Implementation
**Estimated Effort**: 1-2 days for core functionality
**Priority**: High (enables Quick Win #1)
**Created**: 2026-02-02
