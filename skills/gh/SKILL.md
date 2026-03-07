---
name: gh
description: >-
  Interact with GitHub using the gh CLI. Use when the user asks to create
  or manage pull requests, issues, releases, or workflows, when querying
  GitHub for information (issues, PRs, code search), or when using the
  GitHub API. Works seamlessly in jj colocated repositories.
---

# GitHub CLI (gh)

## When to Use

- User asks to create, view, merge, or manage a pull request
- User asks about GitHub issues, checks, releases, or discussions
- Best source of information is on GitHub (issue details, PR reviews, code search)
- User mentions GitHub Actions or workflow runs
- User needs to query the GitHub API (REST or GraphQL)

## Essential Commands

| Command | Purpose |
|---|---|
| `gh pr create` | Create a pull request |
| `gh pr list` | List pull requests |
| `gh pr view NUMBER` | View a pull request |
| `gh pr merge NUMBER` | Merge a pull request |
| `gh pr checkout NUMBER` | Check out a PR branch locally |
| `gh issue create` | Create an issue |
| `gh issue list` | List issues |
| `gh issue view NUMBER` | View an issue |
| `gh search code "PATTERN"` | Search code across repos |
| `gh search issues "QUERY"` | Search issues across GitHub |
| `gh search prs "QUERY"` | Search pull requests across GitHub |
| `gh api ENDPOINT` | Call the GitHub REST API |
| `gh api graphql` | Call the GitHub GraphQL API |
| `gh run list` | List workflow runs |
| `gh run view RUN_ID` | View a workflow run |
| `gh run watch RUN_ID` | Watch a run until it completes |
| `gh release list` | List releases |
| `gh release create TAG` | Create a release |
| `gh repo view` | View repository info |

## Structured Output

Always use `--json` and `--jq` for machine-readable output. This is critical for LLM agents — never rely on human-formatted table output.

```bash
# List open PRs with specific fields
gh pr list --json number,title,state,headRefName

# Filter with jq expressions (built-in, no jq install needed)
gh pr list --json number,title,labels --jq '.[] | select(.labels | length > 0)'

# Get PR details as JSON
gh pr view 42 --json title,body,reviews,comments

# List failed CI runs
gh run list --json name,status,conclusion --jq '.[] | select(.conclusion == "failure")'
```

`gh api` returns JSON by default — no extra flags needed.

## Pull Request Workflow

### Creating PRs

Always push your bookmark first, then create the PR:

```bash
# Push the bookmark (creates the remote branch)
jj git push

# Create a PR with title and body
gh pr create --title "feat(scope): description" --body "$(cat <<'EOF'
## Summary

Description of the changes.

## Changes

- Change 1
- Change 2
EOF
)"

# Create a draft PR (default — see Safety Rules)
gh pr create --draft --title "feat(scope): description" --body "Description"

# Create PR against a specific base branch
gh pr create --base main --title "..." --body "..."
```

### Viewing and Managing PRs

```bash
# View PR details
gh pr view 42 --json title,body,state,reviews

# View PR comments via API
gh api repos/{owner}/{repo}/pulls/42/comments

# Check CI status on a PR
gh pr checks 42

# Enable auto-merge when checks pass
gh pr merge 42 --auto --squash
```

### Merge Strategies

Always specify the merge strategy explicitly:

```bash
gh pr merge 42 --squash   # Squash and merge (most common)
gh pr merge 42 --rebase   # Rebase and merge
gh pr merge 42 --merge    # Create a merge commit
```

## Querying GitHub

Use gh as an information source to understand issues, find code, and explore repos.

```bash
# Search code in a specific repo
gh search code "pattern" --repo owner/repo

# Search code across all repos in an org
gh search code "pattern" --owner org-name

# Search issues with GitHub search syntax
gh issue list --search "is:open label:bug sort:updated-desc"

# Search issues across GitHub
gh search issues "error message" --repo owner/repo

# Paginate large result sets
gh api repos/{owner}/{repo}/issues --paginate
```

### GraphQL Queries

Use GraphQL for complex queries that would require multiple REST calls:

```bash
gh api graphql -f query='
  query($owner: String!, $repo: String!) {
    repository(owner: $owner, name: $repo) {
      issues(first: 10, states: OPEN) {
        nodes {
          number
          title
          labels(first: 5) { nodes { name } }
        }
      }
    }
  }
' -F owner='{owner}' -F repo='{repo}'
```

Use `-F` for variables (handles type coercion) and `-f` for the query string.

## jj Compatibility

gh works seamlessly in colocated jj/git repos — no extra configuration needed.

- **Always push with `jj git push`** before running `gh pr create`
- **jj bookmarks map to git branches** — gh sees them as regular branches
- **Use `jj git fetch`** (not `git fetch`) after gh operations that modify remote state (e.g., merging a PR)
- **Never use raw git commands** — stick to jj for version control, gh for GitHub interaction

### Pushing a New Bookmark

Before pushing a newly created bookmark for the first time, you must track it:

```bash
jj bookmark create feature-name -r @
jj bookmark track feature-name@origin
jj git push --bookmark feature-name
```

If you skip the `track` step, `jj git push` will refuse to create the new remote bookmark.

### Typical jj + gh Flow

```bash
# Start work
jj new main -m "feat(scope): description"
jj bookmark create feature-name -r @

# Track and push the bookmark
jj bookmark track feature-name@origin
jj git push --bookmark feature-name

# Create a draft PR
gh pr create --draft --title "feat(scope): description" --body "Description"

# After review, merge
gh pr merge NUMBER --squash

# Fetch the merged result
jj git fetch
```

## Common Patterns

```bash
# Create PR from jj bookmark (track first if new)
jj bookmark track feature-name@origin
jj git push --bookmark feature-name
gh pr create --draft --title "feat(scope): description" --body "Description"

# Check CI status
gh run list --json status,conclusion,name --jq '.[:5]'

# Read an issue for context
gh issue view 123

# Search for related code
gh search code "functionName" --repo owner/repo

# List recent releases
gh release list --limit 5

# View repo info
gh repo view --json description,defaultBranchRef,stargazerCount
```

## Safety Rules

- **Never use interactive flags** — always provide `--title`, `--body`, and other required flags explicitly. LLMs cannot interact with editors or prompts.
- **Never close or delete PRs/issues without user confirmation.**
- **Never merge PRs without user confirmation.**
- **Always create PRs as drafts** (`--draft`) unless the user explicitly says otherwise.
- **Always pass PR body inline or via HEREDOC** — never rely on editor prompts.
- **Never store or expose tokens** — gh manages authentication; never log or echo tokens.
