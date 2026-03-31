#!/bin/bash
# skill-sync.sh - Synchronize installed skills to registry repository
#
# Usage: ./skill-sync.sh [--dry-run] [--verbose]

set -e

REGISTRY_REPO="https://github.com/gallifreyCar/my-claude-skills-registry"
REGISTRY_DIR="/tmp/skills-registry-$(date +%s)"
DRY_RUN=false
VERBOSE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run) DRY_RUN=true; shift ;;
        --verbose) VERBOSE=true; shift ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

log() {
    if [[ "$VERBOSE" == "true" ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
    fi
}

# Step 1: Clone registry repository
log "Cloning registry repository..."
if [[ "$DRY_RUN" == "false" ]]; then
    git clone "$REGISTRY_REPO" "$REGISTRY_DIR" 2>/dev/null || {
        log "Repository already cloned or clone failed"
        exit 1
    }
fi

# Step 2: Discover custom skills
log "Discovering custom skills..."
CUSTOM_SKILLS_DIR="$HOME/.claude/skills"
if [[ -d "$CUSTOM_SKILLS_DIR" ]]; then
    for skill_dir in "$CUSTOM_SKILLS_DIR"/*/; do
        skill_name=$(basename "$skill_dir")
        skill_file="$skill_dir/SKILL.md"
        if [[ -f "$skill_file" ]]; then
            log "Found custom skill: $skill_name"
            if [[ "$DRY_RUN" == "false" ]]; then
                mkdir -p "$REGISTRY_DIR/skills/custom"
                cp "$skill_file" "$REGISTRY_DIR/skills/custom/$skill_name.md"
            fi
        fi
    done
fi

# Step 3: Discover plugin skills
log "Discovering plugin skills..."
PLUGIN_CACHE="$HOME/.claude/plugins/cache"
if [[ -d "$PLUGIN_CACHE" ]]; then
    while IFS= read -r skill_file; do
        log "Found plugin skill: $skill_file"
        # Extract plugin name from path
        plugin_name=$(echo "$skill_file" | sed -E 's|.*/plugins/cache/[^/]+/([^/]+)/.*|\1|')
        skill_name=$(basename "$(dirname "$skill_file")")
        if [[ "$DRY_RUN" == "false" ]]; then
            mkdir -p "$REGISTRY_DIR/skills/plugins/$plugin_name"
            cp "$skill_file" "$REGISTRY_DIR/skills/plugins/$plugin_name/$skill_name.md"
        fi
    done < <(find "$PLUGIN_CACHE" -name "SKILL.md" -type f 2>/dev/null)
fi

# Step 4: Update sync log
log "Updating sync log..."
SYNC_DATE=$(date '+%Y-%m-%d %H:%M:%S')
if [[ "$DRY_RUN" == "false" ]]; then
    echo "| $SYNC_DATE | Auto-sync | All skills | skill-sync.sh |" >> "$REGISTRY_DIR/SYNC_LOG.md"
fi

# Step 5: Commit and push
if [[ "$DRY_RUN" == "false" ]]; then
    log "Committing changes..."
    cd "$REGISTRY_DIR"
    git add -A
    git commit -m "Auto-sync skills at $SYNC_DATE" || log "No changes to commit"
    git push origin main || log "Push failed"
    log "Sync complete!"
else
    log "Dry run complete - no changes made"
fi

# Cleanup
if [[ "$DRY_RUN" == "false" ]]; then
    rm -rf "$REGISTRY_DIR"
fi

echo "Skills sync completed successfully."