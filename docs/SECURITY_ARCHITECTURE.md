# Security architecture

## Status

The static site and local controls described here exist as of 2026-11-26. The public GitHub repository, repository ruleset, GitHub Pages configuration, HTTPS observations, and live verification remain pending Phases 6–9. The deployment sections describe the accepted target architecture and label unobserved controls accordingly.

## System context

```text
 Local workstation
 ┌───────────────────────────────────────────────┐
 │ HTML + CSS + portrait + public documentation │
 │ Git history ── SSH signing agent/private key │
 │ check.sh and local browser verification      │
 └──────────────────────┬────────────────────────┘
                        │ signed push (pending)
             TB1: local / GitHub boundary
                        ▼
 GitHub control plane
 ┌───────────────────────────────────────────────┐
 │ Maintainer account and signing-key identity   │
 │ Public repository: main (pending)             │
 │ Ruleset and security settings (pending)       │
 └──────────────────────┬────────────────────────┘
                        │ managed Pages deployment
             TB2: repository / hosting boundary
                        ▼
 GitHub Pages
 ┌───────────────────────────────────────────────┐
 │ GitHub-managed workflow, origin, CDN, TLS     │
 │ Static files from main and /(root) (pending)  │
 └──────────────────────┬────────────────────────┘
                        │ HTTPS responses
              TB3: hosting / public internet
                        ▼
 Visitor browser
 ┌───────────────────────────────────────────────┐
 │ Enforces meta CSP and no-referrer             │
 │ Renders local HTML, CSS, and portrait         │
 │ May navigate to GitHub, LinkedIn, or email    │
 └──────────────────────┬────────────────────────┘
                        │ outbound navigation
             TB4: project / external services
                        ▼
              Independent service providers
```

The signing private key and account-recovery material remain on the maintainer side of TB1 and are never publication inputs.

## Components and responsibilities

| Component | Responsibility | Operator | Current state |
| --- | --- | --- | --- |
| `index.html` and `404.html` | Semantic content, metadata, and browser policy | Project | Implemented and locally verified |
| `styles/main.css` | All visual styling | Project | Implemented; local asset only |
| `assets/portrait.jpg` | Approved public portrait | Project | Metadata-processed and inspected |
| `scripts/check.sh` | Enforce frozen source constraints | Project | Implemented; positive and negative tested |
| Local Git repository | Trusted history and recovery source | Project/maintainer | Four locally valid SSH-signed commits through Phase 5 |
| GitHub account | Administrative identity and key association | GitHub/maintainer | Dedicated signing key registered; sanitized Phase 6 account/email review complete |
| Public repository and ruleset | Store public history and enforce branch rules | GitHub/maintainer | Pending Phase 7 |
| Managed Pages workflow | Transfer branch content into Pages hosting | GitHub | Pending Phase 8; no project workflow file |
| Pages origin, CDN, and TLS | Serve public files and HTTPS | GitHub | Pending Phase 8 observation |
| Visitor browser | Enforce applicable policy and render files | Visitor/browser vendor | Local Chromium policy probe completed; release/live matrices pending |

## Trust boundaries

### TB1 — Local workstation to GitHub

A push moves public source and signed commit objects from a maintainer-controlled environment to GitHub. Authentication credentials and the signing private key do not cross as repository content. The account, network, SSH agent, remote URL, and reviewed commit set are security-sensitive at this boundary.

### TB2 — Repository to managed deployment

GitHub reads the configured publishing branch and runs its Pages deployment infrastructure. The project controls committed files and, after configuration, the selected source; GitHub controls the workflow implementation, service identity, artifacts, and hosting infrastructure. Comparing a deployment to its expected signed commit is the principal integrity check.

### TB3 — Pages to the public browser

GitHub controls TLS termination and response headers. The project controls HTML content, the meta-delivered CSP, the referrer meta policy, and local assets. The browser decides how supported policy is enforced. Live response and browser behavior remain unverified until deployment.

### TB4 — Portfolio to external destinations

Anchor navigation to GitHub, LinkedIn, and email leaves the project. No destination content is embedded, fetched as a runtime dependency, or granted project credentials. The project controls the link target but not the destination's subsequent behavior.

## Request flow

The live request flow is pending Phase 8 deployment. Its intended sequence is:

1. A visitor requests `https://saibshuvro.github.io/`.
2. GitHub's Pages edge terminates HTTPS and returns the static `index.html` selected from a deployed commit.
3. The browser reads the early meta CSP before the stylesheet, icon, or portrait loads.
4. The browser requests `/styles/main.css` and `/assets/portrait.jpg` from the same origin. The policy denies scripts, network connections initiated by page APIs, forms, objects, base changes, and unspecified resource classes.
5. The browser renders public text and links. Project code creates no cookies, local storage, telemetry, API request, or server-side record.
6. Following a profile or Email link is a new navigation controlled by the browser and destination provider, not a project resource request.

The custom 404 flow uses the same local CSS, icon, CSP, and referrer policy. Its live status-code behavior is pending a unique-path test in Phase 9.

## Deployment flow

The deployment flow is accepted but not active:

1. The maintainer reviews public content and runs local static, metadata, secret, and browser checks.
2. The maintainer creates an SSH-signed commit. Local signature verification uses an untracked allowed-signers file under `.git/`.
3. Phase 7 adds the reviewed public remote and pushes `main` only after account hardening and release checks pass.
4. GitHub associates the public signing key and displays a `Verified` result when its verification succeeds. That status remains pending the first push.
5. A narrow `main` ruleset requires signed commits and blocks force pushes and deletion, subject to configured bypass permissions. This control remains pending remote setup.
6. Pages branch publishing selects `main` and `/(root)`. GitHub runs a managed Pages workflow even though the repository contains no custom workflow.
7. The maintainer compares the deployed commit to the reviewed signed commit, checks HTTPS and redirects, and records sanitized live evidence.

## Control map

| Layer | Project-owned controls | GitHub-operated controls | Verification state |
| --- | --- | --- | --- |
| Browser | No JavaScript; local assets; exact meta CSP; `no-referrer`; no forms, embeds, storage, analytics, or API use | None for project HTML enforcement; browsers enforce supported policy | Source inspection, `check.sh`, and local Chromium CSP probe complete; full matrix/live checks pending |
| Repository | Small public tree; narrow `.gitignore`; signed local commits; no workflow or dependency files | Git storage, signature display, ruleset engine, audit/security features | Local signatures valid; remote protections and GitHub `Verified` pending |
| Account | Dedicated signing key; private material excluded from Git | Authentication, sessions, key registration, security log, recovery mechanisms | Signing key registration and sanitized Phase 6 account/email review confirmed |
| Deployment | Plain static files, `.nojekyll`, accepted `main`/`/(root)` source, no custom workflow | Managed Pages workflow, environment, hosting, CDN, TLS, service availability | Entire layer pending Phase 8–9 |
| Verification | `check.sh`, manual review, disposable negative tests, public evidence rules | Deployment status, commit verification, security alerts and settings UI | Local static evidence complete; Gitleaks, remote, deployment, and live evidence pending |

Repository rulesets and account settings are project-selected but GitHub-enforced. An administrator may be able to change or bypass protections depending on actual permissions and configuration; rulesets therefore do not replace account security.

## Why the project holds no visitor data

The publication contains no backend, database, authentication, contact form, comments, analytics, advertising, service worker, cookies, browser-storage calls, or application JavaScript. Static files are requested from GitHub Pages, and no project-controlled endpoint receives visitor-submitted content. GitHub may process ordinary hosting and request data under its own service operation; that processing is outside this repository and is not represented as project-owned storage.

The `mailto:` link delegates message composition and delivery to the visitor's chosen client and mail providers. A message sent voluntarily becomes email data handled by those providers and the maintainer, not data collected by website code.

## Response-header and CSP boundary

The project delivers CSP through `<meta http-equiv="Content-Security-Policy">` because the chosen Pages setup does not expose repository-controlled arbitrary response headers. This provides meaningful resource restrictions but not every header-delivered capability:

- `frame-ancestors` and `sandbox` are ignored in a meta CSP, so the project cannot independently prevent framing or apply a document sandbox;
- CSP reporting directives are not supported through the meta element, and the project has no reporting endpoint;
- project code cannot set response headers such as `Permissions-Policy`, `X-Content-Type-Options`, or a project-selected `Strict-Transport-Security` value; and
- a HEAD response cannot demonstrate the HTML meta policy, so browser inspection remains necessary.

Clickjacking is accepted while the site remains noninteractive. Adding authentication, sensitive forms, or state-changing behavior triggers an architecture and hosting review.

## Platform references

Reviewed on 2026-11-26:

- [GitHub: Configuring a publishing source for a GitHub Pages site](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site)
- [GitHub: Securing a GitHub Pages site with HTTPS](https://docs.github.com/en/pages/getting-started-with-github-pages/securing-your-github-pages-site-with-https)
- [GitHub Community: HTTP headers on Pages](https://github.com/orgs/community/discussions/54257)
- [MDN: Content Security Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/CSP)
- [MDN: `frame-ancestors`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Security-Policy/frame-ancestors)
- [MDN: `report-uri`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Security-Policy/report-uri)
