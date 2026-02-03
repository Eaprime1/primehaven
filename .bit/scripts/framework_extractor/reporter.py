"""
Extraction Reporter - Generate summary reports after extraction
"""

from typing import List, Dict
from collections import defaultdict


class ExtractionReporter:
    """Generate extraction summary reports"""

    def __init__(self):
        self.reset()

    def reset(self):
        """Reset statistics"""
        self.processed_files = 0
        self.extracted_frameworks = []
        self.flagged_frameworks = []
        self.failed_files = []
        self.no_pattern_files = []
        self.start_time = None
        self.end_time = None

    def add_extracted(self, framework: Dict):
        """Record an extracted framework"""
        self.extracted_frameworks.append(framework)

    def add_flagged(self, framework: Dict):
        """Record a flagged framework (needs review)"""
        self.flagged_frameworks.append(framework)

    def add_failed(self, file_path: str, error: str):
        """Record a failed file"""
        self.failed_files.append({'file': file_path, 'error': error})

    def add_no_pattern(self, file_path: str):
        """Record a file with no patterns"""
        self.no_pattern_files.append(file_path)

    def generate_report(self, source: str, duration_seconds: float) -> str:
        """
        Generate comprehensive extraction report

        Args:
            source: Source path that was processed
            duration_seconds: Time taken for extraction

        Returns:
            Formatted report string
        """
        # Calculate statistics
        total_extracted = len(self.extracted_frameworks)
        total_flagged = len(self.flagged_frameworks)
        total_failed = len(self.failed_files)
        total_no_pattern = len(self.no_pattern_files)

        # Group by category
        by_category = defaultdict(int)
        for fw in self.extracted_frameworks:
            category = fw.get('metadata', {}).get('category', 'unknown')
            by_category[category] += 1

        # Group by prime association (if any)
        by_prime = defaultdict(int)
        # TODO: Extract prime associations from metadata

        # Format duration
        duration_str = self._format_duration(duration_seconds)

        # Build report
        report = f"""Framework Extraction Report
===========================
Source: {source}
Processed: {self.processed_files} documents
Duration: {duration_str}

Results:
  ✓ {total_extracted} frameworks extracted (high confidence ≥0.8)
  ? {total_flagged} frameworks flagged for review (medium confidence 0.5-0.8)
  ✗ {total_failed} documents failed to parse
  ○ {total_no_pattern} documents contained no triadic patterns

"""

        # Category breakdown
        if by_category:
            report += "Breakdown by Category:\\n"
            for category, count in sorted(by_category.items()):
                category_name = category.replace('-', ' ').title()
                report += f"  {category_name}: {count} frameworks\\n"
            report += "\\n"

        # Output locations
        if self.extracted_frameworks:
            report += "Output Locations:\\n"
            locations = defaultdict(int)
            for fw in self.extracted_frameworks:
                output_path = fw.get('output_path', '')
                if output_path:
                    # Get directory
                    import os
                    directory = os.path.dirname(output_path)
                    locations[directory] += 1

            for directory, count in sorted(locations.items()):
                report += f"  {directory}: {count} files\\n"
            report += "\\n"

        # Failed files details
        if self.failed_files:
            report += "Failed Files:\\n"
            for failed in self.failed_files[:10]:  # Limit to 10
                report += f"  - {failed['file']} ({failed['error']})\\n"
            if len(self.failed_files) > 10:
                report += f"  ... and {len(self.failed_files) - 10} more\\n"
            report += "\\n"

        # Next steps
        report += "Next Steps:\\n"
        if total_flagged > 0:
            report += f"  1. Review {total_flagged} flagged frameworks for validation\\n"
        if total_extracted > 0:
            report += "  2. Validate high-confidence extractions\\n"
            report += "  3. Run: em-validator --confidence-threshold 0.8\\n"
            report += "  4. Promote validated frameworks to production\\n"

        return report

    def _format_duration(self, seconds: float) -> str:
        """Format duration in human-readable format"""
        if seconds < 60:
            return f"{seconds:.1f}s"
        elif seconds < 3600:
            minutes = int(seconds / 60)
            secs = int(seconds % 60)
            return f"{minutes}m {secs}s"
        else:
            hours = int(seconds / 3600)
            minutes = int((seconds % 3600) / 60)
            return f"{hours}h {minutes}m"

    def get_summary_stats(self) -> Dict:
        """Get summary statistics as dict"""
        return {
            'processed_files': self.processed_files,
            'extracted_count': len(self.extracted_frameworks),
            'flagged_count': len(self.flagged_frameworks),
            'failed_count': len(self.failed_files),
            'no_pattern_count': len(self.no_pattern_files)
        }
