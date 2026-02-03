#!/bin/bash
# Entity Git-Type Initialization Template
# Usage: ./entity-git-type-init-template.sh <entity-name> <perspective> [project-root]

set -e

ENTITY_NAME=$1
PERSPECTIVE=$2
PROJECT_ROOT=${3:-$(pwd)}

if [ -z "$ENTITY_NAME" ] || [ -z "$PERSPECTIVE" ]; then
    echo "Usage: $0 <entity-name> <perspective> [project-root]"
    echo ""
    echo "Examples:"
    echo "  $0 suxen individual"
    echo "  $0 nexus systemic /path/to/project"
    echo "  $0 suxenexus emergent"
    echo ""
    echo "Perspectives: individual, systemic, emergent, precision, creative, wisdom"
    exit 1
fi

GITTYPE_DIR="$PROJECT_ROOT/.$ENTITY_NAME"

echo "Initializing .$ENTITY_NAME git-type..."
echo "  Entity: $ENTITY_NAME"
echo "  Perspective: $PERSPECTIVE"
echo "  Location: $GITTYPE_DIR"
echo ""

# Create structure
mkdir -p "$GITTYPE_DIR"/{objects,refs/{heads,tags,remotes},hooks,logs,info}

# Create config
cat > "$GITTYPE_DIR/config" << EOF
[core]
    perspective = $PERSPECTIVE
    entity = $ENTITY_NAME
    version = 1.0
    created = $(date -Iseconds)

[tracking]
    enabled = true
    auto_timestamp = true

[integration]
    auto_sync = false
    ready_branch = integration
EOF

# Create description
cat > "$GITTYPE_DIR/description" << EOF
Git-type for $ENTITY_NAME entity
Perspective: $PERSPECTIVE consciousness tracking
EOF

# Create HEAD
echo "ref: refs/heads/main" > "$GITTYPE_DIR/HEAD"

# Create hooks directory with example
cat > "$GITTYPE_DIR/hooks/pre-commit.sample" << 'EOF'
#!/bin/bash
# Pre-commit hook for entity git-type
# Add custom validation here
echo "Entity perspective check..."
EOF

# Create initial branch
mkdir -p "$GITTYPE_DIR/refs/heads"
echo "0000000000000000000000000000000000000000" > "$GITTYPE_DIR/refs/heads/main"

echo "✅ .$ENTITY_NAME git-type initialized successfully!"
echo ""
echo "Next steps:"
echo "  1. Customize $GITTYPE_DIR/config for entity-specific needs"
echo "  2. Create initial commit: gtm commit --type $ENTITY_NAME -m 'Initial commit'"
echo "  3. Set up integration points with other git-types"
echo ""

∰◊€π¿
EOF
chmod +x /home/sauron/primehaven/.bit/templates/entity-git-type-init-template.sh
