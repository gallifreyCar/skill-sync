# Skill Sync

A Claude Code skill that automatically synchronizes installed skills documentation to a registry repository.

## Installation

Copy this skill to your Claude skills directory:

```bash
mkdir -p ~/.claude/skills/skill-sync
cp -r . ~/.claude/skills/skill-sync
```

## Usage

### Manual Sync

In Claude Code, say:
```
sync my skills to the registry
```

### After Installing New Skill

```
I installed a new skill, sync the registry
```

### View Registry

```
show me my skills registry
```

## What It Does

1. **Scans** all installed skills in:
   - `~/.claude/skills/` (custom skills)
   - `~/.claude/plugins/cache/` (plugin skills)

2. **Extracts** skill metadata:
   - Name and description
   - GitHub source link
   - Installation location

3. **Updates** the registry repository:
   - Creates individual skill documentation
   - Updates sync log
   - Commits and pushes changes

## Configuration

Edit `references/config.json` to customize:

```json
{
  "registry_repo": "https://github.com/gallifreyCar/my-claude-skills-registry",
  "sync_on_install": true,
  "branch": "main"
}
```

## Requirements

- `gh` CLI authenticated with GitHub
- Git installed
- Write access to registry repository

## Files

| File | Purpose |
|------|---------|
| `SKILL.md` | Skill definition and workflow |
| `scripts/skill-sync.sh` | Bash script for synchronization |
| `references/config.json` | Configuration file |
| `references/discovery-patterns.md` | Skill discovery patterns |

## Related

- Registry Repository: https://github.com/gallifreyCar/my-claude-skills-registry