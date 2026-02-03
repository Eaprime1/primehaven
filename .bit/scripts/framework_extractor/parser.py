"""
Document Parser - Extract text and structure from documents
Handles: docx, txt, md
"""

import os
import zipfile
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Dict, List, Optional
from dataclasses import dataclass


@dataclass
class DocumentSection:
    """Represents a section of a document"""
    level: int  # Heading level (1=h1, 2=h2, etc., 0=paragraph)
    title: Optional[str]  # Section title (if heading)
    content: str  # Text content
    start_line: int  # Line number in source
    word_count: int  # Number of words


class DocumentParser:
    """Parse documents and extract structured content"""

    def __init__(self):
        self.sections: List[DocumentSection] = []

    def parse(self, file_path: str) -> Dict:
        """
        Parse document and return structured content

        Args:
            file_path: Path to document file

        Returns:
            Dict with 'sections', 'text', 'file_name', 'format'
        """
        path = Path(file_path)

        if not path.exists():
            raise FileNotFoundError(f"File not found: {file_path}")

        file_ext = path.suffix.lower()

        if file_ext == '.docx':
            return self._parse_docx(file_path)
        elif file_ext == '.txt':
            return self._parse_txt(file_path)
        elif file_ext == '.md':
            return self._parse_markdown(file_path)
        else:
            raise ValueError(f"Unsupported file format: {file_ext}")

    def _parse_docx(self, file_path: str) -> Dict:
        """Parse DOCX file using zipfile + XML"""
        try:
            sections = []
            full_text = []
            line_num = 0

            with zipfile.ZipFile(file_path, 'r') as docx:
                # Extract document.xml
                xml_content = docx.read('word/document.xml')
                tree = ET.fromstring(xml_content)

                # Namespace for DOCX
                ns = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}

                # Extract paragraphs
                for para in tree.findall('.//w:p', ns):
                    # Get text from paragraph
                    texts = para.findall('.//w:t', ns)
                    para_text = ''.join(t.text for t in texts if t.text)

                    if not para_text.strip():
                        continue

                    line_num += 1
                    full_text.append(para_text)

                    # Check if it's a heading (simplified - look for style)
                    style_elem = para.find('.//w:pStyle', ns)
                    is_heading = False
                    heading_level = 0

                    if style_elem is not None:
                        style_val = style_elem.get('{http://schemas.openxmlformats.org/wordprocessingml/2006/main}val', '')
                        if 'Heading' in style_val:
                            is_heading = True
                            # Extract heading level (Heading1, Heading2, etc.)
                            try:
                                heading_level = int(style_val.replace('Heading', ''))
                            except:
                                heading_level = 1

                    # Create section
                    word_count = len(para_text.split())
                    section = DocumentSection(
                        level=heading_level if is_heading else 0,
                        title=para_text if is_heading else None,
                        content=para_text,
                        start_line=line_num,
                        word_count=word_count
                    )
                    sections.append(section)

            return {
                'sections': sections,
                'text': '\\n'.join(full_text),
                'file_name': Path(file_path).name,
                'format': 'docx'
            }

        except Exception as e:
            raise Exception(f"Failed to parse DOCX: {str(e)}")

    def _parse_txt(self, file_path: str) -> Dict:
        """Parse plain text file"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                lines = f.readlines()

            sections = []
            line_num = 0

            for line in lines:
                line_num += 1
                text = line.strip()

                if not text:
                    continue

                word_count = len(text.split())

                # Simple heuristic: short lines (< 60 chars) might be headings
                is_heading = len(text) < 60 and word_count < 10 and text[0].isupper()

                section = DocumentSection(
                    level=1 if is_heading else 0,
                    title=text if is_heading else None,
                    content=text,
                    start_line=line_num,
                    word_count=word_count
                )
                sections.append(section)

            return {
                'sections': sections,
                'text': '\\n'.join(lines),
                'file_name': Path(file_path).name,
                'format': 'txt'
            }

        except Exception as e:
            raise Exception(f"Failed to parse TXT: {str(e)}")

    def _parse_markdown(self, file_path: str) -> Dict:
        """Parse Markdown file"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                lines = f.readlines()

            sections = []
            line_num = 0

            for line in lines:
                line_num += 1
                text = line.strip()

                if not text:
                    continue

                # Detect markdown headings (# ## ### etc.)
                heading_level = 0
                is_heading = False

                if text.startswith('#'):
                    # Count # characters
                    heading_level = len(text) - len(text.lstrip('#'))
                    is_heading = True
                    # Remove # and whitespace
                    text = text.lstrip('#').strip()

                word_count = len(text.split())

                section = DocumentSection(
                    level=heading_level if is_heading else 0,
                    title=text if is_heading else None,
                    content=text,
                    start_line=line_num,
                    word_count=word_count
                )
                sections.append(section)

            return {
                'sections': sections,
                'text': '\\n'.join(lines),
                'file_name': Path(file_path).name,
                'format': 'md'
            }

        except Exception as e:
            raise Exception(f"Failed to parse Markdown: {str(e)}")
