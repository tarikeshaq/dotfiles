---
name: jj
description: >-
  Operate Jujutsu (jj) version control repositories. Use when the project
  uses jj instead of git, when .jj/ directory is present, or when the user
  mentions jj, Jujutsu, bookmarks, or revsets. Covers commits, rebasing,
  conflict resolution, bookmarks, and pushing to remotes.
---

# Jujutsu (jj) Version Control

## Core Mental Model

jj is fundamentally different from git. Internalize these concepts:

- **Working copy IS a commit** — the `@` revision. There is no staging area.
- **All file changes are automatically tracked** — no `git add` equivalent needed.
- **Commits are immutable** — editing a commit creates a new revision; the old one is hidden.
- **Descendants auto-rebase** — when you edit an ancestor, all descendants rebase automatically.
- **Conflicts are first-class** — rebase never fails; conflicts are recorded in the commit and resolved later.
- **Use `jj split` instead of `git add -p`** — to break a commit into parts.

## Essential Commands

| Command | Purpose |
|---|---|
| `jj status` | Show working copy status |
| `jj log` | Show commit graph (includes conflict markers) |
| `jj diff` | Show changes in working copy |
| `jj new` | Create a new child commit on top of current |
| `jj commit -m "msg"` | Describe current commit and create a new empty one on top |
| `jj describe -m "msg"` | Set/change current commit's message |
| `jj edit REVISION` | Switch to editing an existing commit |
| `jj rebase -d DEST` | Move current commit (and descendants) onto DEST |
| `jj squash` | Fold current commit's changes into its parent |
| `jj split [PATHS]` | Split current commit into two (use path args, never `-i`) |
| `jj bookmark create NAME -r REV` | Create a bookmark at a revision |
| `jj bookmark set NAME -r REV` | Move an existing bookmark to a revision |
| `jj git fetch` | Fetch from remote |
| `jj git push` | Push bookmarks to remote |
| `jj resolve` | Open merge tool to resolve conflicts |
| `jj undo` | Undo the last jj operation |
| `jj op log` | Show operation history (safety net) |

## Available Aliases

These aliases are configured in the user's `jj/config.toml`:

### Shorthands
- `jj c` — `commit`
- `jj r` — `rebase`
- `jj s` — `squash`
- `jj e` — `edit`

### Stack Operations
- `jj ls` — Log the stack: show all bookmarks descending from `@-`
- `jj ps` — Push the stack: push all bookmarks descending from `@-`
- `jj tug` — Move the nearest bookmark forward to `@-`
- `jj nb NAME` — Create a new bookmark at `@-`
- `jj push` — `git push` (allows new bookmarks without extra flags)

### Revset Aliases
- `st(x)` — All bookmark commits that are descendants of revision `x`
- `closest_bookmark(to)` — Nearest bookmark in the ancestry path to revision `to`

## Workflow Guidelines

1. **Always check state first** — run `jj status` and `jj log` before making changes.
2. **Set messages with `jj describe`** — no staging needed, just describe the current commit.
3. **Use `jj new` to start work** — creates a child commit on top of current.
4. **Use `jj commit -m "msg"`** — shorthand for describe + new.
5. **Start features from main** — `jj new main -m "feat(scope): description"`.
6. **Never use raw git commands** — always use `jj git push`, `jj git fetch`, etc.
7. **Check for conflicts in `jj log`** — conflict markers appear in the log output.
8. **Use `jj undo` if something goes wrong** — it reverts the last operation.

## Commit Message Conventions

Use conventional commit format with `jj describe`:

```
jj describe -m "type(scope): subject"
```

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

- Imperative mood ("add feature" not "added feature")
- No capital first letter, no trailing period
- Keep subject under 50 characters

## Common Patterns

```bash
# Start a new feature from main
jj new main -m "feat(scope): description"

# Create a bookmark for pushing
jj bookmark create feature-name -r @

# Rebase onto latest main
jj rebase -d main

# Squash fixup into parent
jj squash

# Split a commit by file paths (non-interactive)
jj split path/to/file1 path/to/file2

# Resolve conflicts
jj resolve

# Push work to remote
jj git push

# See what's on the stack
jj ls

# Push the whole stack
jj ps
```

## Safety Rules

- **Never run raw `git` commands** in a jj repo — use `jj git *` subcommands.
- **Never delete the `.jj/` directory.**
- **Never force-push** without explicit user confirmation.
- **Never use interactive flags** (`-i`, `--interactive`, `--tool=:builtin`) — these require terminal interaction which LLMs cannot provide. Use non-interactive alternatives: `jj split` with file path arguments, `jj describe -m` instead of opening an editor.
- **Avoid creating temporary files in the repo** — jj auto-tracks all files. Use `/tmp` or another directory outside the repo for scratch files.
