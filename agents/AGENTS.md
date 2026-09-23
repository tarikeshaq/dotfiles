# Global Agent Instructions

These instructions come from my dotfiles (`~/code/dotfiles/agents/AGENTS.md`) and apply to every project. A project's own `CLAUDE.md` / `AGENTS.md` wins where they conflict.

## Environment

- Linux under WSL2 (GPU/windowing may not work natively), zsh + Oh My Zsh, tmux, Neovim.
- GitHub user: `tarikeshaq`. Use the `gh` CLI for GitHub operations.
- Repos live under `~/code/<name>`.

## How I like to work

- **Plan, then mini-milestones.** For non-trivial work, state what/why/how first, then split it into small milestones that each end with passing tests and a commit. For long efforts, persist the plan in the repo's `AGENTS.md`/`CLAUDE.md` so it survives across sessions.
- **Red-green, incremental.** Write the failing test first, make it pass, move on. Test small pieces before composing them. One feature at a time.
- **Checkpoint often.** For multi-step features: one PR at the end with one commit per testable step, so I can check out any intermediate state. Every commit compiles and passes tests.
- **Tests are necessary, not sufficient.** If a change touches a live system (API, cloud resource, deploy), also run the real smoke path before calling it done.
- **Record shortcuts.** When deferring something, note it in the repo's `TECH_DEBT.md` (or equivalent) in the same commit.
- **Terse responses.** No long trailing summaries; I read the diff.
- **Keep it simple.** Fix the actual bug, don't restructure around it. In shell one-liners prefer plain pipes (`cmd | jq | xargs`) over intermediate variables and nested `$(...)`.
- **Explain before mutating cloud state.** Before any `gcloud`/`bq`/`terraform`/`kubectl`/`docker push` command whose verb creates, updates, deletes, enables, deploys, or applies, state in a sentence what it does and its blast radius, then wait for my go-ahead. This holds even for "diagnostic" commands. Prefer read-only alternatives (`list`, `describe`, `plan`, `--dry-run`).

## Architecture Decision Records

Every project gets a `docs/adr/` directory. Create it (with `0000-template.md`) when scaffolding a new project, or the first time a decision comes up in an existing one.

- **When to write one:** any decision a future reader would otherwise have to reverse-engineer or might "fix" by mistake. Examples: picking a library or framework over alternatives, a data model or wire format, an infra topology, a deliberate constraint ("runtime-checked queries, not compile-time"), or abandoning an earlier plan. When in doubt, write it; they're short.
- **File name:** `docs/adr/NNNN-kebab-title.md`, numbered sequentially from `0001`; never reuse a number.
- **Format** (short Nygard style):
  ```markdown
  # NNNN. Title

  - Status: Proposed | Accepted | Superseded by [NNNN](NNNN-....md) | Deprecated
  - Date: YYYY-MM-DD

  ## Context
  The forces at play: problem, constraints, what we knew at the time.

  ## Decision
  What we chose, stated actively ("We will ...").

  ## Alternatives considered
  Each option and why it lost.

  ## Consequences
  What gets easier, what gets harder, what we're now committed to.
  ```
- **ADRs are immutable once Accepted.** To change course, write a new ADR and mark the old one `Superseded by NNNN`; don't rewrite history. Fixing typos or adding links is fine.
- **Same change as the code.** Land the ADR in the same PR/commit as the code it justifies. Put `Proposed` ADRs up for review before building on them.
- **Keep the agent docs lean.** The repo's `AGENTS.md`/`CLAUDE.md` should link to relevant ADRs rather than hold decision logs inline. Before reversing an existing pattern, check `docs/adr/` for the reason it exists.

## Version control

- Use **jj** when the repo has a `.jj/` directory (most of mine do, colocated with git); load the `jj` skill. Otherwise git.
- Conventional commits: `type(scope): subject` — imperative, lowercase, no trailing period, ≤50 chars. Types: `feat fix docs style refactor test chore perf`.
- Never use interactive flags (`-i`, `--interactive`).
- Never `--no-verify`. If a pre-commit hook fails, the commit didn't happen: fix it and make a new commit, don't amend.

## Languages

**Rust is my language of choice.** Use it for new services, CLIs, and tools unless I say otherwise. TypeScript is for the browser (and generated client code). Use Python only in existing Python projects or where the ecosystem forces it (such as ML notebooks).

### Rust conventions

- **Workspace layout:** a root `Cargo.toml` with `resolver = "3"`, `edition = "2024"`, and shared `[workspace.package]` + `[workspace.dependencies]`. Member crates use `{ workspace = true }`. Crates go under `crates/<prefix>-<name>`.
- **Lib/bin split:** logic lives in libraries (`-core`, `-domain`, per-integration crates); the binary crate is thin wiring. Commit `Cargo.lock`.
- **Errors:** `thiserror` in libraries, `anyhow` in binaries, `miette` when a CLI shows diagnostics against source spans. Return `Result` everywhere. No `unwrap`/`expect`/`panic!` in library code.
- **Lints:** `[workspace.lints]` with `unsafe_code = "deny"` and `unused_must_use = "deny"`. Use `clippy.toml` `disallowed-methods` to enforce project invariants (such as routing time through a `Clock` trait), and never silence those with `#[allow]`.
- **Correctness defaults:**
  - `rust_decimal::Decimal` for money, never `f64`.
  - Time goes through an injectable `Clock` trait in anything that replays or backtests.
  - External systems sit behind traits so tests can substitute fakes.
- **Common crates:**
  - Runtime and HTTP: `tokio`, `axum` + `tower-http`, `reqwest` (`default-features = false`, `rustls-tls`).
  - Data: `serde`/`serde_json`, `sqlx` (Postgres, rustls, runtime-checked `query_as`, not the compile-time `query!` macros).
  - Ops: `tracing` + `tracing-subscriber` (env-filter, JSON in prod), `clap` (derive), `figment` for config, `uuid` v7, `gcp_auth` for GCP tokens (don't shell out to `gcloud` from code).
- **Tests:**
  - Unit tests live next to the code.
  - `insta` for snapshot tests (review with `cargo insta review`); `proptest` for invariants.
  - CLI tests use `assert_cmd` + `tempfile` + `predicates`.
  - For codegen, compile the generated output end-to-end in a test.
- **Green check before every commit:**
  ```bash
  cargo fmt --all -- --check
  cargo clippy --workspace --all-targets -- -D warnings
  cargo test --workspace --all-targets
  ```
- rust-analyzer lags after `Cargo.toml` edits. Trust `cargo check` over stale LSP diagnostics.
- **Docker:** multi-stage build. Use `cargo-chef` (or BuildKit `--mount=type=cache` on the registry and `target/`) to cache dependencies. Runtime image is `debian:bookworm-slim` with only `ca-certificates`, run as `USER nobody:nogroup`. Listen on `$PORT` (default `8080`) for Cloud Run.

### Other languages

- **TypeScript/Node:** `npm` with a committed `package-lock.json`; `npm ci` in CI.
- **Python (existing projects only):** `uv` only (`uv sync`, `uv run`, `uv add`). Never `pip install`, `python -m venv`, or virtualenv. Commit `uv.lock` and `.python-version`.

## Default app stack (new web apps, unless told otherwise)

- Backend: Rust (`axum` + `tokio` + `sqlx` + `tracing`). Frontend: Next.js + Tailwind (TypeScript).
- Data: Postgres (Cloud SQL, `pgvector` when embeddings are involved); blobs in GCS.
- Auth: Google OIDC (frontend gets an ID token, backend verifies it against Google's JWKS).
- **Single code path, no local/prod branching.** Local dev uses real-shaped dependencies: Postgres in Docker, `fsouza/fake-gcs-server` for GCS (`STORAGE_EMULATOR_HOST`), and ADC (`gcloud auth application-default login`) against the staging project for managed APIs.
- App state and clients are built once at startup and injected (axum `State`, trait objects), so tests can substitute fakes.

## Cloud: GCP + Terraform

I use **GCP** via `gcloud`, managed with **Terraform**. Default region `us-central1` for everything (avoid cross-region egress). Find the billing account with `gcloud billing accounts list`; don't guess it.

### Terraform safety rules (non-negotiable)

1. Edit `.tf` → `terraform fmt` → `terraform validate` → `terraform plan -out=tfplan`.
2. Show me the plan and call out anything unexpected (replacements and destroys especially).
3. Apply only after I say so, and apply the saved plan: `terraform apply tfplan`. Never run `-auto-approve` locally, and never apply without a plan I've seen, including when repairing a half-failed apply.
4. Never `terraform destroy`, `state rm`, or `import` without explicit approval.
5. Never re-run a project's bootstrap script unless I ask for re-bootstrapping.

### Project topology

- **User-facing apps:** three GCP projects sharing a random 6-hex suffix (project IDs are globally unique; generate with `openssl rand -hex 3`):
  - `<app>-admin-<sfx>`: Terraform state bucket, Terraform SA, WIF pool. **Not managed by Terraform.**
  - `<app>-staging-<sfx>` and `<app>-prod-<sfx>`: managed by Terraform, referenced via `data "google_project"` (not created by it).
- **Personal/research tools:** a single project (`<app>-<sfx>` or `<app>-teshaq`) with state bucket `<project>-tf-state` in the same project.
- Naming: short `<app>` prefix for project-scoped resources (`<app>-runtime`, `<app>-ci`); the full project ID or suffix for globally unique ones (buckets).

### Bootstrap (`infra/bootstrap/bootstrap.sh`)

A one-time, **idempotent** `gcloud` script (`set -euo pipefail`, `describe || create` for every resource) for the chicken-and-egg pieces Terraform can't own:

- Create projects and link billing.
- Enable APIs on the admin project: `cloudresourcemanager iam iamcredentials sts storage cloudbilling`.
- State bucket: uniform bucket-level access plus versioning.
- `terraform@<admin>.iam.gserviceaccount.com` with `roles/owner` on each managed project.
- WIF pool `github-pool` with OIDC provider `github-provider` (issuer `https://token.actions.githubusercontent.com`), with `attribute.repository` mapped and an attribute condition restricting to my repo(s). Bind the SA with `roles/iam.workloadIdentityUser` on `principalSet://…/attribute.repository/tarikeshaq/<repo>`.
- Print the admin project number, WIF provider path, and SA email for GitHub secrets.

Reference implementation: `tarikeshaq/learnit`, file `infra/bootstrap/bootstrap.sh` (local clone at `~/code/learnit`).

### Repo layout

Infra lives **inside the app monorepo** under `infra/`, not in a separate `-tf` repo. That way a change needing both app code and infra wiring (such as a new env var) lands in one PR. I migrated learnit off a separate repo for this reason.

```
infra/
  bootstrap/bootstrap.sh
  modules/<name>/{main,variables,outputs}.tf
  environments/{staging,prod}/
    backend.tf        # gcs backend: bucket=<state bucket>, prefix=<env>
    providers.tf      # required_version + pinned providers (~> major)
    main.tf           # module calls
    variables.tf
    outputs.tf
    terraform.tfvars  # committed: NON-secret values only
    .terraform.lock.hcl  # committed
```

- Environments are separate root modules (directories), **not workspaces**. Run commands from inside `infra/environments/<env>`.
- Environment-specific resources go in that env's `main.tf`. Shared patterns become a module called from each env.
- Terraform `>= 1.5` (for `import` blocks). Pin providers with `~>` on the current major for new projects; match the existing pin in existing projects.
- `.gitignore`: `.terraform/`, `*.tfstate*`, `tfplan`, `*.tfplan`, `crash*.log`, `override.tf*`, `*_override.tf*`, `*.tfvars.json`. Keep lock files tracked.

### Standard modules (copy from `tarikeshaq/learnit`, directory `infra/modules/`)

| Module | Purpose |
|---|---|
| `project` | `google_project_service` for an API list (`disable_on_destroy = false`) |
| `service-account` | SA + list of project-level roles |
| `cloud-run` | Cloud Run v2: public invoker, Cloud SQL volume, env + secret env, startup probe, min/max instances |
| `database` | Cloud SQL Postgres 16, `random_password` user, `ssl_mode = ENCRYPTED_ONLY` |
| `storage` | GCS bucket |
| `registry` | Artifact Registry Docker repo |
| `secrets` | Secret Manager secret + version + accessor binding for one SA |
| `dns` | Cloud DNS public zone, DNSSEC on |
| `cloud-run-domain` | Cloud Run domain mapping + CNAME to `ghs.googlehosted.com.` |

### Patterns I use

- **Image ownership belongs to app CI.** The `cloud-run` module sets `lifecycle { ignore_changes = [template[0].containers[0].image] }`; `image` only seeds creation (default `us-docker.pkg.dev/cloudrun/container/hello`). App CI deploys with `gcloud run deploy`.
- **Keyless CI everywhere.** GitHub Actions auth uses WIF (`google-github-actions/auth@v2`), never SA keys. `ADMIN_PROJECT_NUMBER` is the only repo secret needed to build the provider path.
- **Separate SAs:** a runtime SA per service with least-privilege roles (`cloudsql.client`, `storage.objectAdmin`, `aiplatform.user`, …), and a CI SA (`<app>-ci`) with `artifactregistry.writer`, `run.developer`, `iam.serviceAccountUser` plus its own WIF binding.
- **Secrets:** generated secrets (DB URLs) go Terraform → Secret Manager → Cloud Run `secret_env_vars`. Third-party API keys are **never** in `terraform.tfvars`. Pass them as `TF_VAR_<name>` (GitHub secret in CI, exported locally).
- **Dormant features:** gate optional modules on a variable (`count = var.domain_name != "" ? 1 : 0`) so code can merge before an external prerequisite exists.
- **Cross-env reads:** shared resources (e.g., the apex DNS zone) live in prod. Staging reads them via `data "terraform_remote_state" "prod"` wrapped in `try(..., null)` so first applies don't break.
- **Resources GCP auto-creates** (for example the Cloud DNS zone made by Cloud Domains registration): adopt them with an `import {}` block instead of letting Terraform 409 on create.

### CI/CD

- `.github/workflows/terraform.yml`: `dorny/paths-filter` → env matrix (changes to `modules/**` hit both envs), then `plan -no-color` on PR posted as a PR comment and `apply -auto-approve` on push to `main`. Permissions: `id-token: write`, `pull-requests: write`. In a monorepo, trigger only on `infra/**`.
- `.github/workflows/ci.yml`:
  - `concurrency` with `cancel-in-progress`.
  - Rust job: `dtolnay/rust-toolchain@stable` + `Swatinem/rust-cache@v2`, running the fmt/clippy/test green check with a Postgres service container and fake-gcs-server when needed.
  - Frontend job: `npm ci && next build`.
- `.github/workflows/deploy.yml`: on push to `main`, build → push to Artifact Registry with the `main-<sha7>` tag → `gcloud run deploy` → curl `/health`.

### GCP gotchas I've already paid for

- **Cloud Run domain mappings** 403 ("Caller is not authorized to administer the domain") unless the Terraform SA is a verified **Owner** of the domain in Google Search Console. This is a manual step per domain.
- **`--cpu-boost` is per-revision.** Every `gcloud run deploy` must pass it or the new revision silently drops it. The same applies to any revision-level flag Terraform set but CI redeploys over.
- **Cloud Tasks calling back into the same Cloud Run service** needs three grants: `cloudtasks.enqueuer` on the runtime SA; `iam.serviceAccountTokenCreator` for the Cloud Tasks service agent *on* the runtime SA; and `iam.serviceAccountUser` for the runtime SA **on itself** (checked at enqueue time, otherwise `CreateTask` 403s).
- The `*.run.app` URL isn't known until after creation. Use the custom domain for OIDC audiences and CORS to avoid chicken-and-egg problems.
- Cost defaults for staging/research: Cloud SQL `db-f1-micro` (zonal), Cloud Run `min_instances = 0`. Call out anything that adds meaningful idle cost (GKE control plane, HA Cloud SQL, min instances > 0) before adding it.
