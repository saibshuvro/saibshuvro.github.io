# GitHub Pages deployment review — 2026-11-26

## Scope and target

This Phase 8 record covers the GitHub Pages configuration and managed deployment of signed commit `ae4ba54a3061a2693db0c503f8509658fc0887ad` to `https://saibshuvro.github.io/`. Evidence combines public GitHub API responses, live HTTP/browser observations, and a sanitized owner review of the authenticated Pages settings. Account screenshots, cookies, authorization data, and private configuration exports are excluded.

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

## Phase boundary

This record establishes the publishing source, known deployed signed commit, managed deployment success, HTTPS enforcement, canonical redirect, and absence of mixed content for the tested load. Phase 9 still performs the broader live response-header, unique-path 404, responsive, keyboard, console, network, and outbound-link verification against the deployed origin.

This documentation update must itself be signed, pushed through the active ruleset, marked `Verified`, and followed by a successful managed deployment before Phase 8 closes.
