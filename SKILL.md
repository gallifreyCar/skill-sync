---
name: skill-sync
description: Automatically sync installed skills documentation to the registry repository when new skills are installed. Trigger when user asks to sync skills, update skill registry, or after installing a new skill.
---

# Skill Sync

Automatically synchronize Claude Code skills documentation to the registry repository.

## Purpose

When you install a new skill, this skill ensures the documentation is automatically updated in the registry repository (https://github.com/gallifreyCar/my-claude-skills-registry).

## Trigger Conditions

- User says "sync skills", "update skill registry", "sync to repo"
- After installing a new skill (manual trigger)
- User asks to document installed skills

## Workflow

### Step 1: Discover Installed Skills

Scan all skill locations:

```bash
# Custom skills
ls -la ~/.claude/skills/

# Plugin skills
find ~/.claude/plugins/cache -name "SKILL.md" -type f
```

### Step 2: Extract Skill Information

For each skill found, extract:
- `name` from frontmatter
- `description` from frontmatter
- `github` link (if in frontmatter)
- SKILL.md content summary
- Installation location

### Step 3: Update Registry Repository

1. Clone/update the registry repo:
   ```bash
   git clone https://github.com/gallifreyCar/my-claude-skills-registry.git /tmp/skills-registry
   ```

2. Create/update individual skill documentation in `skills/{category}/{skill-name}.md`

3. Update SYNC_LOG.md with sync timestamp

4. Commit and push changes

### Step 4: Report Results

Inform user of:
- Skills synced
- New skills added
- Files changed
- Commit URL

## Skill Categories

Skills are organized into three categories:

| Category | Location in Registry | Source |
|----------|---------------------|--------|
| `built-in` | skills/built-in/ | Claude Code native |
| `plugins` | skills/plugins/ | Installed plugins |
| `custom` | skills/custom/ | ~/.claude/skills/ |

## Output Format

Each skill document follows this template:

```markdown
# {skill-name}

## Metadata
- **Source**: {github link or "Built-in" or "Custom"}
- **Location**: {file path}
- **Plugin**: {plugin name if applicable}

## Description
{description from frontmatter}

## Usage
{usage examples}

## Key Features
{extracted from SKILL.md content}

## References
{links to related docs/scripts}
```

## Configuration

Registry repository URL is configured in:
- `~/.claude/skills/skill-sync/references/config.json`

Default: `https://github.com/gallifreyCar/my-claude-skills-registry`

## Notes

- Only syncs when explicitly triggered
- Preserves existing documentation structure
- Does not delete skills from registry (only adds/updates)
- Requires `gh` CLI authentication for push operations