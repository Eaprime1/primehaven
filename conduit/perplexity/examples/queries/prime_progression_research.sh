#!/usr/bin/env bash
# Example: Research prime numbers in consciousness development

# Query external sources about prime numbers and consciousness
perplexity -uc -m sonar-pro \
  "How do prime numbers appear in consciousness development theories, sacred geometry, and universal patterns across cultures?" \
  > ../workspace/research/prime_consciousness_external.md

# Query about specific prime transitions
perplexity -uc \
  "What is significant about the numbers 3, 5, 7, 11, 13, and 17 in mathematics, physics, and philosophy?" \
  > ../workspace/research/prime_significance.md

# Synthesize with PrimeHaven framework
perplexity -m sonar-pro \
  "Compare how different cultures and disciplines view the number 7 as a completion or perfection number" \
  > ../workspace/synthesis/seven_universal_pattern.md

echo "Research complete. Check workspace/research/ and workspace/synthesis/"
