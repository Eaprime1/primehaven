"""
Confidence Scorer - Calculate confidence scores for detected patterns
"""

from typing import Dict


class ConfidenceScorer:
    """Calculate confidence scores for detected triadic patterns"""

    @staticmethod
    def calculate_score(pattern: Dict, detection_method: str) -> float:
        """
        Calculate confidence score for a pattern

        Args:
            pattern: Detected pattern with vector, anti_vector, prime
            detection_method: 'keyword' or 'llm-deep'

        Returns:
            Confidence score (0.0-1.0)
        """
        if detection_method == 'keyword':
            return ConfidenceScorer._score_keyword_pattern(pattern)
        elif detection_method == 'llm-deep':
            return ConfidenceScorer._score_llm_pattern(pattern)
        else:
            return 0.5  # Default medium confidence

    @staticmethod
    def _score_keyword_pattern(pattern: Dict) -> float:
        """Score keyword-detected pattern"""
        base_score = 0.5

        # Add for explicit markers (already verified in detection)
        base_score += 0.3

        # Add for all three parts present
        vector = pattern.get('vector', {})
        anti_vector = pattern.get('anti_vector', {})
        prime = pattern.get('prime', {})

        if all([vector, anti_vector, prime]):
            base_score += 0.1

        # Add for substantial content (>50 words each)
        vector_wc = vector.get('word_count', 0)
        anti_vector_wc = anti_vector.get('word_count', 0)
        prime_wc = prime.get('word_count', 0)

        if all(wc > 50 for wc in [vector_wc, anti_vector_wc, prime_wc]):
            base_score += 0.1

        # Deduct for very short content (<20 words)
        if any(wc < 20 for wc in [vector_wc, anti_vector_wc, prime_wc]):
            base_score -= 0.2

        return max(0.0, min(base_score, 1.0))

    @staticmethod
    def _score_llm_pattern(pattern: Dict) -> float:
        """Score LLM-detected pattern (future)"""
        # TODO: Implement LLM confidence scoring
        # Would use LLM's own confidence + pattern validation
        return 0.7  # Medium confidence for LLM-detected

    @staticmethod
    def categorize_confidence(score: float) -> str:
        """Categorize confidence score into High/Medium/Low"""
        if score >= 0.8:
            return "High"
        elif score >= 0.5:
            return "Medium"
        else:
            return "Low"

    @staticmethod
    def should_auto_extract(score: float, threshold: float = 0.8) -> bool:
        """Determine if pattern should be auto-extracted"""
        return score >= threshold

    @staticmethod
    def should_prompt_human(score: float, min_threshold: float = 0.5, max_threshold: float = 0.8) -> bool:
        """Determine if pattern should prompt for human review"""
        return min_threshold <= score < max_threshold
