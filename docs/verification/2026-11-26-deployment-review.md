# GitHub Pages deployment and post-deployment review — 2026-11-26

## Scope and target

This record covers the Phase 8 GitHub Pages configuration and managed deployment of signed commit `ae4ba54a3061a2693db0c503f8509658fc0887ad`, its signed documentation follow-up `ccd64191fb4934960373375026b9564d6f748238`, and the Phase 9 public deployment/repository review for `https://saibshuvro.github.io/`. Evidence combines public GitHub API responses, live HTTP/browser observations, and sanitized owner review of authenticated settings. Account screenshots, cookies, authorization data, raw signatures, and private configuration exports are excluded.

## Publishing configuration

The authenticated repository settings showed:

- source: `Deploy from a branch`;
- branch: `main`;
- folder: `/(root)`;
- custom domain: empty; and
- Enforce HTTPS: checked and required for the default `saibshuvro.github.io` domain.

The Save button was disabled because the effective branch and folder already matched the intended configuration. The repository contains `.nojekyll` and no `.github/workflows/` path, so no project-authored deployment workflow or custom hosting layer was introduced.

## Managed deployment

- Workflow run: `45808028346` (`pages build and deployment`)
- Event and branch: `dynamic` on `main`
- Head commit: `ae4ba54a3061a2693db0c503f8509658fc0887ad`
- Run started: `2026-11-26T11:09:45Z`
- Deployment identifier: `8083533516`
- Deployment result: `success`
- Deployment completed: `2026-11-26T11:10:13Z` (`17:10:13` Asia/Dhaka)
- Environment URL: `https://saibshuvro.github.io/`

The managed `build`, `report-build-status`, and `deploy` jobs all completed successfully. No warning, failure, manual rerun, or unexplained retry was observed.

## HTTPS and deployed-content checks

- HTTPS homepage response: `200`
- HTTP response: `301 Moved Permanently` to the canonical HTTPS URL
- HTTPS response included `Strict-Transport-Security: max-age=31556952`
- Headless Google Chrome rendered the approved identity and tagline and reported no mixed-content or failed-network error.

The following live resources returned `200` at their direct URLs and matched the signed commit byte-for-byte:

| Resource | SHA-256 |
| --- | --- |
| `index.html` | `703074dc69163466648e229e5f6b0ef5e55c8c9fc7d1cb88d35fd449edf7f48f` |
| `styles/main.css` | `9c2f60bcf7fb63cb4d89b4083cd7b4923f5753d7febde073a0f09799aed1fa29` |
| `assets/portrait.jpg` | `f07a4e88fc2a613c00aa49058d14998863a73985da5cfd6f0fe2201364099384` |
| `404.html` | `57dafe928c0a74003ba30d4e5bb9a43faffbb57436e29b559aae4515a2f175a0` |

## Signed follow-up and Phase 8 closeout

The signed Phase 8 evidence update became commit `ccd64191fb4934960373375026b9564d6f748238`. GitHub marked it verified and completed managed Pages run `45842124644` successfully at `2026-11-26T14:45:26Z`. Deployment `8088371167` targeted the same commit and its final status was `success` at the public environment URL. This closed the Phase 8 follow-up gate.

## Phase 9 deployment and repository state

The public API and local tree were reviewed again during the Phase 9 live check:

- local `HEAD`, `origin/main`, the latest managed run, and the latest deployment all identified `ccd64191fb4934960373375026b9564d6f748238`;
- GitHub reported that commit's verification as valid;
- the only three workflow runs were the expected successful, dynamic, GitHub-managed `pages build and deployment` runs;
- the repository contained no `.github/workflows/` path or other YAML workflow file;
- the `main-integrity` ruleset remained active for the default branch, with no bypass actor and the `deletion`, `non_fast_forward`, and `required_signatures` rules; and
- the same-day sanitized authenticated review documented read-only default Actions token permissions, pull-request creation/approval disabled, Secret Protection and push protection enabled, and no secret-scanning alert; no authorized change to those controls followed before this review.

The broader live observations are recorded in the dated [headers](2026-11-26-http-headers.txt), [redirect](2026-11-26-redirect-check.txt), and [browser checklist](2026-11-26-browser-checklist.md) evidence. The public site passed those checks against the known signed commit. Raw API payloads and screenshots were not committed.
