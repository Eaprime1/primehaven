#!/usr/bin/env bash
# Example: Research antigravity concepts and transformation physics

# Quantum physics - electron positron transformation
perplexity -uc -m sonar-pro \
  "Explain electron-positron annihilation in detail. Is it destruction or transformation? What about quantum superposition?" \
  > ../workspace/research/electron_positron_physics.md

# Antimatter and transformation
perplexity -uc \
  "What happens when matter meets antimatter at the quantum level? Photon creation, energy states, and transformation processes." \
  > ../workspace/research/antimatter_transformation.md

# Fractal nature of particles
perplexity -c \
  "History of particle physics discoveries: atoms to quarks and beyond. What's the current smallest known particle?" \
  > ../workspace/research/particle_fractals.md

# Synergy and field theory
perplexity -m sonar-pro \
  "What are fields of influence vs forces in physics? How do electromagnetic, gravitational, and quantum fields differ?" \
  > ../workspace/research/fields_vs_forces.md

echo "Antigravity research complete. Check workspace/research/"
