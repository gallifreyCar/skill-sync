# Skill Discovery Patterns

## Custom Skills Location

```
~/.claude/skills/{skill-name}/SKILL.md
```

Each skill directory contains:
- `SKILL.md` (required) - Skill definition
- `scripts/` (optional) - Executable scripts
- `references/` (optional) - Reference documents
- `assets/` (optional) - Static assets

## Plugin Skills Location

```
~/.claude/plugins/cache/{marketplace}/{plugin}/{version}/skills/{skill-name}/SKILL.md
```

Marketplaces:
- `claude-plugins-official` - Anthropic official plugins
- `{custom-marketplace}` - Custom marketplace plugins

## Frontmatter Fields

Required:
- `name` - Skill identifier
- `description` - When to trigger, what it does

Optional:
- `github` - Source repository URL
- `license` - License type
- `metadata` - Additional metadata (author, version, etc.)
- `disable-model-invocation` - Whether to disable auto-invocation

## Discovery Script Pattern

```bash
# Find all SKILL.md files
find ~/.claude -name "SKILL.md" -type f

# Parse frontmatter
grep -A 10 "^---" SKILL.md | head -20
```

## Built-in Skills

Built-in skills don't have SKILL.md files. They are:
- `update-config`
- `keybindings-help`
- `simplify`
- `loop`
- `schedule`
- `claude-api`

These are documented manually in the registry.