"""
Framework Extractor - Generate EM v2.0 tagged markdown from detected patterns
"""

import os
from datetime import datetime
from pathlib import Path
from typing import Dict
import re


class FrameworkExtractor:
    """Extract frameworks and generate EM v2.0 tagged markdown"""

    def __init__(self, output_dir: str = "staged/frameworks"):
        self.output_dir = output_dir

    def extract_framework(self, pattern: Dict, source_file: str, confidence: float) -> Dict:
        """
        Generate EM v2.0 markdown from pattern

        Args:
            pattern: Detected TriadicPattern
            source_file: Source document path
            confidence: Confidence score

        Returns:
            Dict with output_path, content, metadata
        """
        # Generate EM v2.0 tagged markdown
        markdown = self._generate_markdown(pattern, source_file, confidence)

        # Determine output path
        output_path = self._determine_output_path(pattern)

        # Ensure output directory exists
        os.makedirs(os.path.dirname(output_path), exist_ok=True)

        # Write file
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(markdown)

        return {
            'output_path': output_path,
            'content': markdown,
            'metadata': {
                'name': pattern.name,
                'confidence': confidence,
                'category': pattern.category,
                'source': source_file
            }
        }

    def _generate_markdown(self, pattern: Dict, source_file: str, confidence: float) -> str:
        """Generate EM v2.0 tagged markdown"""

        timestamp = datetime.now().isoformat()
        confidence_label = "High" if confidence >= 0.8 else ("Medium" if confidence >= 0.5 else "Low")
        status = "Auto-extracted" if confidence >= 0.8 else "Needs validation"

        # Determine prime number association (future: could be auto-detected)
        prime_tag = ""  # Could add prime:13 etc. based on content

        markdown = f"""<!-- EM:v2.0 framework:triadic category:{pattern.category}{prime_tag} confidence:{confidence:.2f} -->
<!-- source:{source_file} -->
<!-- extracted:{timestamp} -->
<!-- extractor:framework-extractor v1.0 mode:{pattern.detection_method} -->

# Framework: {pattern.name}

## {pattern.vector['title']}

{pattern.vector['content']}

## {pattern.anti_vector['title']}

{pattern.anti_vector['content']}

## {pattern.prime['title']}

{pattern.prime['content']}

---

## Metadata

- **Source**: {Path(source_file).name}
- **Extracted**: {timestamp}
- **Confidence**: {confidence:.2f} ({confidence_label} - {status})
- **Method**: {pattern.detection_method.title()} matching
- **Status**: {status}
- **Category**: {pattern.category.replace('-', ' ').title()} triadic framework

---

## Application Notes

[Space for human to add application context during validation]

---

∰◊€π¿
"""

        return markdown

    def _determine_output_path(self, pattern: Dict) -> str:
        """Determine output file path based on category"""

        # Slugify framework name for filename
        slug = self._slugify(pattern.name)

        # Determine subdirectory based on category
        if pattern.category == 'decision-space':
            subdir = 'triadic/decision-spaces'
        elif pattern.category == 'reality-anchor':
            subdir = 'triadic/reality-anchors'
        elif pattern.category == 'entity-signature':
            subdir = 'triadic/entity-signatures'
        else:
            subdir = 'triadic'

        # Build full path
        output_path = os.path.join(self.output_dir, subdir, f"{slug}.md")

        return output_path

    def _slugify(self, text: str) -> str:
        """Convert text to slug (lowercase, hyphens, no special chars)"""
        # Convert to lowercase
        text = text.lower()

        # Replace spaces and underscores with hyphens
        text = re.sub(r'[\\s_]+', '-', text)

        # Remove special characters
        text = re.sub(r'[^a-z0-9-]', '', text)

        # Remove multiple consecutive hyphens
        text = re.sub(r'-+', '-', text)

        # Trim hyphens from start and end
        text = text.strip('-')

        # Limit length
        if len(text) > 50:
            text = text[:50].rstrip('-')

        return text or 'framework'
