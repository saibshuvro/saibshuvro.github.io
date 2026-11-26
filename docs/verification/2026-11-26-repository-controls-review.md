# Repository controls review — 2026-11-26

## Scope and evidence boundary

This review covers the first public push and the repository controls configured for `saibshuvro/saibshuvro.github.io`. It uses public GitHub API results plus sanitized owner attestations for authenticated settings. Private keys, passphrases, cookies, recovery material, raw account exports, and settings screenshots are intentionally excluded.

## Public history and identity

- Local `main`, `origin/main`, and GitHub identified commit `961f879874d1728db8b03b361f9d6e157e50a34f` as the first-push branch tip.
- The six reviewed commits were present remotely without an extra initialization commit.
- GitHub reported every commit as `verified: true` with reason `valid` after the existing professional committer address was associated with and verified on the maintainer account.
- The temporary `no_user` result was an identity-association issue, not a cryptographic signature failure. No commit was rewritten and no force push occurred.
- SSH authentication and commit signing use separate passphrase-protected Ed25519 keys. Repository-local SSH configuration selects the authentication key with `IdentitiesOnly=yes` so the separate side-project account is not offered accidentally.

## Secret protection

- The owner confirmed GitHub Secret Protection is enabled for the repository.
- Repository push protection is enabled.
- The owner reviewed secret-scanning alerts and reported none.
- No allowlist, ignored alert, or bypass was used as evidence of a clean state.
- Dependency automation and CodeQL/default setup remain absent because this static project has no dependency graph or application-code scanning requirement.

Gitleaks and GitHub secret scanning are complementary pattern-based controls; neither is represented as complete coverage of every credential format.

## Actions permissions

- The default `GITHUB_TOKEN` permission is restricted to reading repository contents and packages.
- GitHub Actions cannot create or approve pull requests.
- No project-authored workflow exists under `.github/workflows/`.
- GitHub automatically completed one managed `pages-build-deployment` run after the first push. This platform-managed run does not change the no-custom-workflow decision.

## Default-branch ruleset

GitHub's public ruleset API returned the following effective configuration:

- name: `main-integrity`;
- enforcement: `active`;
- target: `branch` with `~DEFAULT_BRANCH` and no exclusions;
- bypass actors: none; and
- rules: `deletion`, `non_fast_forward`, and `required_signatures`.

No pull-request, status-check, deployment, linear-history, creation, or update restriction is enabled. This keeps ordinary verified direct maintenance possible while rejecting unsigned commits, default-branch deletion, and non-fast-forward history replacement.

This evidence update is the first ordinary signed branch update prepared after activation. GitHub acceptance and signature verification of its resulting commit are checked before Phase 7 is closed.

## Remaining work

Deliberate Pages source review, HTTPS and deployed-commit confirmation, live response inspection, and live browser/404 checks remain Phases 8–9. A successful managed run alone is not treated as completion of those checks.
