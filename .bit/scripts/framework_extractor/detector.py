"""
Pattern Detector - Identify triadic patterns in documents
Fast Pass: Keyword matching
Deep Pass: LLM analysis (future)
"""

import re
from typing import Dict, List, Optional
from dataclasses import dataclass


@dataclass
class TriadicPattern:
    """Represents a detected triadic pattern"""
    name: str
    vector: Dict  # {title, content, start_line, word_count}
    anti_vector: Dict
    prime: Dict
    confidence: float
    detection_method: str  # 'keyword' or 'llm-deep'
    category: str  # 'decision-space', 'reality-anchor', 'entity-signature'


class PatternDetector:
    """Detect triadic patterns using keyword matching and optional LLM"""

    # Explicit triadic keywords
    VECTOR_KEYWORDS = [
        'vector:', 'thesis:', 'first aspect:', 'part one:',
        'body:', 'work:', 'individual:', 'physical:'
    ]

    ANTI_VECTOR_KEYWORDS = [
        'anti-vector:', 'antithesis:', 'second aspect:', 'part two:',
        'mind:', 'play:', 'systemic:', 'digital:'
    ]

    PRIME_KEYWORDS = [
        'prime:', 'synthesis:', 'third aspect:', 'part three:',
        'soul:', 'create:', 'emergent:', 'conceptual:', 'integration:'
    ]

    # Common triadic patterns
    KNOWN_TRIADS = [
        ('body', 'mind', 'soul'),
        ('work', 'play', 'create'),
        ('individual', 'systemic', 'emergent'),
        ('physical', 'digital', 'conceptual'),
        ('thesis', 'antithesis', 'synthesis'),
        ('vector', 'anti-vector', 'prime'),
        ('past', 'present', 'future'),
        ('input', 'process', 'output'),
    ]

    def __init__(self):
        self.patterns: List[TriadicPattern] = []

    def detect_patterns(self, document: Dict, deep_mode: bool = False) -> List[TriadicPattern]:
        """
        Detect triadic patterns in document

        Args:
            document: Parsed document from DocumentParser
            deep_mode: Enable LLM deep analysis (not implemented yet)

        Returns:
            List of detected TriadicPattern objects
        """
        patterns = []

        # Fast pass: keyword matching
        keyword_patterns = self._detect_keyword_patterns(document)
        patterns.extend(keyword_patterns)

        # Deep pass: LLM analysis (future enhancement)
        if deep_mode:
            # TODO: Implement LLM deep analysis
            pass

        return patterns

    def _detect_keyword_patterns(self, document: Dict) -> List[TriadicPattern]:
        """Detect patterns using keyword matching"""
        patterns = []
        sections = document['sections']

        # Look for explicit triadic markers
        i = 0
        while i < len(sections):
            section = sections[i]
            content_lower = section.content.lower()

            # Check if this section starts a triadic pattern
            has_vector = any(kw in content_lower for kw in self.VECTOR_KEYWORDS)

            if has_vector:
                # Try to find anti-vector and prime
                pattern = self._extract_explicit_triad(sections, i)
                if pattern:
                    patterns.append(pattern)
                    i += 3  # Skip the three parts we just extracted
                    continue

            i += 1

        # Look for known triadic patterns (Body/Mind/Soul, etc.)
        known_patterns = self._detect_known_triads(document)
        patterns.extend(known_patterns)

        return patterns

    def _extract_explicit_triad(self, sections: List, start_idx: int) -> Optional[TriadicPattern]:
        """Extract triadic pattern starting at given index"""

        vector_section = sections[start_idx]
        vector_level = vector_section.level

        # Search ahead for anti-vector heading at same level
        anti_vector_idx = None
        for i in range(start_idx + 1, len(sections)):
            if sections[i].level == vector_level:
                # Check if this is anti-vector
                if any(kw in sections[i].content.lower() for kw in self.ANTI_VECTOR_KEYWORDS):
                    anti_vector_idx = i
                    break
                # Stop if we hit another same-level heading that's not anti-vector
                break

        if anti_vector_idx is None:
            return None

        # Search ahead for prime heading at same level
        prime_idx = None
        for i in range(anti_vector_idx + 1, len(sections)):
            if sections[i].level == vector_level:
                # Check if this is prime
                if any(kw in sections[i].content.lower() for kw in self.PRIME_KEYWORDS):
                    prime_idx = i
                    break
                # Stop if we hit another same-level heading that's not prime
                break

        if prime_idx is None:
            return None

        anti_vector_section = sections[anti_vector_idx]
        prime_section = sections[prime_idx]

        # Extract content (get following paragraphs until next heading)
        vector_content = self._extract_section_content(sections, start_idx)
        anti_vector_content = self._extract_section_content(sections, anti_vector_idx)
        prime_content = self._extract_section_content(sections, prime_idx)

        # Calculate confidence
        confidence = self._calculate_keyword_confidence(
            vector_content, anti_vector_content, prime_content
        )

        # Generate framework name from content
        name = self._generate_framework_name(vector_section, anti_vector_section, prime_section)

        return TriadicPattern(
            name=name,
            vector={
                'title': vector_section.title or 'Vector',
                'content': vector_content,
                'start_line': vector_section.start_line,
                'word_count': len(vector_content.split())
            },
            anti_vector={
                'title': anti_vector_section.title or 'Anti-Vector',
                'content': anti_vector_content,
                'start_line': anti_vector_section.start_line,
                'word_count': len(anti_vector_content.split())
            },
            prime={
                'title': prime_section.title or 'Prime',
                'content': prime_content,
                'start_line': prime_section.start_line,
                'word_count': len(prime_content.split())
            },
            confidence=confidence,
            detection_method='keyword',
            category='decision-space'  # Default, can be refined
        )

    def _extract_section_content(self, sections: List, heading_idx: int) -> str:
        """Extract content from heading through following paragraphs"""
        content_parts = []
        heading_level = sections[heading_idx].level

        # Collect following sections until next heading of same or higher level
        i = heading_idx + 1
        while i < len(sections):
            section = sections[i]

            # Stop at next heading of same or higher level (but not lower level headings)
            if section.level > 0 and section.level <= heading_level:
                break

            # Add all content (paragraphs and lower-level headings)
            content_parts.append(section.content)

            i += 1

        # If no content found after heading, just use the heading itself
        if not content_parts:
            content_parts = [sections[heading_idx].content]

        return '\\n\\n'.join(content_parts)

    def _detect_known_triads(self, document: Dict) -> List[TriadicPattern]:
        """Detect known triadic patterns like Body/Mind/Soul"""
        patterns = []
        text_lower = document['text'].lower()

        for triad in self.KNOWN_TRIADS:
            first, second, third = triad

            # Check if all three terms appear in document
            if all(term in text_lower for term in triad):
                # Try to extract the context around these terms
                pattern = self._extract_known_triad_context(document, triad)
                if pattern:
                    patterns.append(pattern)

        return patterns

    def _extract_known_triad_context(self, document: Dict, triad: tuple) -> Optional[TriadicPattern]:
        """Extract context around known triadic terms"""
        first, second, third = triad
        sections = document['sections']

        # Find sections mentioning each term
        first_sections = []
        second_sections = []
        third_sections = []

        for section in sections:
            content_lower = section.content.lower()
            if first in content_lower:
                first_sections.append(section)
            if second in content_lower:
                second_sections.append(section)
            if third in content_lower:
                third_sections.append(section)

        # Need at least one section for each
        if not (first_sections and second_sections and third_sections):
            return None

        # Use the first occurrence of each
        vector_section = first_sections[0]
        anti_vector_section = second_sections[0]
        prime_section = third_sections[0]

        # Extract content around mentions
        vector_content = self._extract_term_context(vector_section.content, first)
        anti_vector_content = self._extract_term_context(anti_vector_section.content, second)
        prime_content = self._extract_term_context(prime_section.content, third)

        confidence = 0.7  # Medium confidence for known patterns

        return TriadicPattern(
            name=f"{first.title()}/{second.title()}/{third.title()} Triad",
            vector={
                'title': first.title(),
                'content': vector_content,
                'start_line': vector_section.start_line,
                'word_count': len(vector_content.split())
            },
            anti_vector={
                'title': second.title(),
                'content': anti_vector_content,
                'start_line': anti_vector_section.start_line,
                'word_count': len(anti_vector_content.split())
            },
            prime={
                'title': third.title(),
                'content': prime_content,
                'start_line': prime_section.start_line,
                'word_count': len(prime_content.split())
            },
            confidence=confidence,
            detection_method='keyword',
            category='decision-space'
        )

    def _extract_term_context(self, text: str, term: str, context_words: int = 50) -> str:
        """Extract context around a term mention"""
        words = text.split()
        term_words = term.split()

        # Find term position
        for i in range(len(words) - len(term_words) + 1):
            if ' '.join(words[i:i+len(term_words)]).lower() == term.lower():
                # Extract context
                start = max(0, i - context_words // 2)
                end = min(len(words), i + len(term_words) + context_words // 2)
                return ' '.join(words[start:end])

        # If not found, return full text (up to context_words)
        return ' '.join(words[:context_words])

    def _calculate_keyword_confidence(self, vector: str, anti_vector: str, prime: str) -> float:
        """Calculate confidence score for keyword-detected pattern"""
        base_score = 0.5

        # Add for explicit markers
        base_score += 0.3  # Already verified in extraction

        # Add for all three parts present
        if vector and anti_vector and prime:
            base_score += 0.1

        # Add for substantial content (>50 words each)
        if all(len(part.split()) > 50 for part in [vector, anti_vector, prime]):
            base_score += 0.1

        return min(base_score, 1.0)

    def _generate_framework_name(self, vector_sec, anti_vector_sec, prime_sec) -> str:
        """Generate framework name from section titles or content"""
        # Try to use section titles
        if vector_sec.title and anti_vector_sec.title:
            # Extract key words from titles
            vector_words = vector_sec.title.replace('Vector:', '').replace('Thesis:', '').strip()
            return vector_words if vector_words else 'Triadic Framework'

        # Fall back to content analysis
        # Get first few words from vector content
        words = vector_sec.content.split()[:5]
        name = ' '.join(words)

        # Capitalize first letter of each word
        return ' '.join(word.capitalize() for word in name.split())
