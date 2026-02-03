"""
Framework Validator - Validate extracted frameworks before saving
"""

from typing import Dict, List, Tuple


class FrameworkValidator:
    """Validate extracted frameworks for quality and completeness"""

    @staticmethod
    def validate(pattern: Dict) -> Tuple[bool, List[str]]:
        """
        Validate a detected pattern

        Args:
            pattern: TriadicPattern to validate

        Returns:
            Tuple of (is_valid, list_of_errors)
        """
        errors = []

        # Check required fields
        if not pattern.name or pattern.name.strip() == '':
            errors.append("Framework name is empty")

        if not pattern.vector or not pattern.vector.get('content'):
            errors.append("Vector content is missing")

        if not pattern.anti_vector or not pattern.anti_vector.get('content'):
            errors.append("Anti-vector content is missing")

        if not pattern.prime or not pattern.prime.get('content'):
            errors.append("Prime content is missing")

        # Check content quality
        vector_content = pattern.vector.get('content', '')
        anti_vector_content = pattern.anti_vector.get('content', '')
        prime_content = pattern.prime.get('content', '')

        # Check minimum word count (>20 words per part)
        if len(vector_content.split()) < 20:
            errors.append(f"Vector content too short ({len(vector_content.split())} words, minimum 20)")

        if len(anti_vector_content.split()) < 20:
            errors.append(f"Anti-vector content too short ({len(anti_vector_content.split())} words, minimum 20)")

        if len(prime_content.split()) < 20:
            errors.append(f"Prime content too short ({len(prime_content.split())} words, minimum 20)")

        # Check for placeholder text
        placeholders = ['[Content]', '[TBD]', '[TODO]', '[description]']
        for placeholder in placeholders:
            if any(placeholder in content for content in [vector_content, anti_vector_content, prime_content]):
                errors.append(f"Placeholder text found: {placeholder}")

        # Check parts are distinct (not just repeating same content)
        if FrameworkValidator._is_duplicate_content(vector_content, anti_vector_content):
            errors.append("Vector and anti-vector have duplicate content")

        if FrameworkValidator._is_duplicate_content(vector_content, prime_content):
            errors.append("Vector and prime have duplicate content")

        if FrameworkValidator._is_duplicate_content(anti_vector_content, prime_content):
            errors.append("Anti-vector and prime have duplicate content")

        # Check confidence score is valid
        if not (0.0 <= pattern.confidence <= 1.0):
            errors.append(f"Invalid confidence score: {pattern.confidence}")

        is_valid = len(errors) == 0
        return is_valid, errors

    @staticmethod
    def _is_duplicate_content(content1: str, content2: str, similarity_threshold: float = 0.8) -> bool:
        """Check if two content strings are too similar"""
        words1 = set(content1.lower().split())
        words2 = set(content2.lower().split())

        if not words1 or not words2:
            return False

        # Calculate Jaccard similarity
        intersection = words1.intersection(words2)
        union = words1.union(words2)

        similarity = len(intersection) / len(union) if union else 0

        return similarity > similarity_threshold
