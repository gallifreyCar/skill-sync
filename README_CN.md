# Skill Sync 中文版

一个 Claude Code 技能，用于自动将已安装技能的文档同步到注册表仓库。

## 安装

将此技能复制到你的 Claude 技能目录：

```bash
mkdir -p ~/.claude/skills/skill-sync
cp -r . ~/.claude/skills/skill-sync
```

## 使用方法

### 手动同步

在 Claude Code 中说：
```
把我的技能同步到注册表
```

或使用英文：
```
sync my skills to the registry
```

### 安装新技能后

```
我安装了一个新技能，同步注册表
```

### 查看注册表

```
显示我的技能注册表
```

## 工作原理

1. **扫描** 所有已安装技能：
   - `~/.claude/skills/`（自定义技能）
   - `~/.claude/plugins/cache/`（插件技能）

2. **提取** 技能元数据：
   - 名称和描述
   - GitHub 源链接
   - 安装位置

3. **更新** 注册表仓库：
   - 创建单个技能文档
   - 更新同步日志
   - 提交并推送更改

## 配置

编辑 `references/config.json` 进行自定义：

```json
{
  "registry_repo": "https://github.com/gallifreyCar/my-claude-skills-registry",
  "sync_on_install": true,
  "branch": "main"
}
```

## 系统要求

- `gh` CLI 已通过 GitHub 认证
- 已安装 Git
- 对注册表仓库有写入权限

## 文件说明

| 文件 | 用途 |
|------|------|
| `SKILL.md` | 技能定义和工作流程 |
| `scripts/skill-sync.sh` | 同步脚本 |
| `references/config.json` | 配置文件 |
| `references/discovery-patterns.md` | 技能发现模式 |

## 相关链接

- 注册表仓库：https://github.com/gallifreyCar/my-claude-skills-registry