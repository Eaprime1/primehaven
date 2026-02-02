# .bit Directory - BBS-Style Architecture

Old-school BBS cascading model for PrimeHaven distributed system.

## Structure

```
.bit/
├── backbone/     # 7-node backbone (FidoNet-style hub architecture)
├── hubs/         # Local minor hubs (domos → hub → backbone)
├── nodes/        # Individual node configurations
└── transforms/   # Communication protocol transformers (FTP, TCP/IP, etc.)
```

## Concept

Inspired by FidoNet and BBS networks of the 1980s-90s:
- **Backbone**: Core routing nodes that interconnect everything
- **Hubs**: Regional concentration points (minor hubs feed into backbone)
- **Nodes**: Individual entities/projects (submit to local hub)
- **Transforms**: Protocol translation layers for different communication types

## Workflow

```
Entity/Domos → Local Hub → Backbone Node → Distribution
```

## Status

- Structure: Created
- Documentation: Initial
- Implementation: Pending
- Integration: Future phase

**Reality Anchor**: This creates the foundation for entities to submit work
through a hierarchical, federated network rather than a centralized system.

∰◊€π¿
