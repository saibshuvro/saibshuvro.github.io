# Security decisions

These architecture decision records describe the repository state as of 2026-11-26. **Accepted** means the design decision is approved; implementation status is stated separately when a GitHub or deployment control remains pending.

## ADR-001 — Static HTML and CSS rather than an application framework

**Status:** Accepted and implemented locally

**Context:** The portfolio displays a portrait, short biography, four links, and a custom error page. It has no dynamic data or application transaction.

**Decision:** Use handwritten semantic HTML and one CSS file with no runtime package, build tool, template engine, or framework.

**Alternatives considered:** React, Next.js, another static-site generator, or a bundled component framework.

**Consequences:** The publication tree is directly inspectable, has no package supply chain, and needs no build artifact provenance. Changes require ordinary HTML/CSS review rather than framework abstractions.

**Limitations:** The project does not gain framework routing, components, automated asset pipelines, or framework-specific optimization. Manual consistency matters as pages are added.

**Review trigger:** A concrete requirement for substantial repeated content, generated pages, or build-time transformation that cannot be handled clearly in the current files.

## ADR-002 — No JavaScript

**Status:** Accepted, implemented, and statically/browser tested locally

**Context:** The approved experience needs no client-side state, animation, form processing, API request, or interactive widget. JavaScript would add executable behavior without serving a present requirement.

**Decision:** Ship no application JavaScript and declare `script-src 'none'` in the CSP. `check.sh` rejects script elements, inline handlers, `javascript:` URLs, and JavaScript files.

**Alternatives considered:** A small enhancement script, a framework runtime, or allowing same-origin scripts in CSP.

**Consequences:** Script-based cross-site scripting and dependency exposure are sharply reduced, the browser behavior is easier to audit, and content remains usable without script execution.

**Limitations:** Features that genuinely require client-side computation are unavailable. CSP is defense in depth rather than proof that arbitrary future HTML is harmless.

**Review trigger:** A user-facing requirement that cannot be met with semantic HTML, CSS, and ordinary navigation. The review must include threat-model, CSP, verifier, privacy, and testing changes before any script is committed.

## ADR-003 — No backend, database, authentication, or contact form

**Status:** Accepted and implemented

**Context:** Every current field is public. The project has no private user account, submitted data, transaction, or server-side computation.

**Decision:** Use no application server, API endpoint, database, login, session, or form. Contact uses a public `mailto:` link.

**Alternatives considered:** A serverless contact form, hosted form provider, application backend, or authenticated administration panel.

**Consequences:** The project stores no visitor-submitted data, needs no application secret, and avoids server-side injection, authentication, session, database, spam-processing, and data-retention responsibilities.

**Limitations:** Visitors need a configured email path to make contact. Email delivery and privacy depend on independent mail providers. The site cannot offer private messages, accounts, or dynamic content.

**Review trigger:** A requirement to receive, store, personalize, or restrict data through the website. Such a change constitutes a new application architecture rather than a small portfolio enhancement.

## ADR-004 — System fonts and local assets only

**Status:** Accepted and implemented

**Context:** The visual design needs a serif typeface and one portrait but does not require a unique webfont or third-party media.

**Decision:** Use a system serif stack and repository-local image/CSS assets. Do not fetch fonts, images, stylesheets, icons, embeds, or media from third parties at runtime.

**Alternatives considered:** Google Fonts, a font CDN, remote profile images, icon libraries, or embedded social content.

**Consequences:** Rendering makes no third-party asset request, avoids another availability and privacy dependency, and permits a narrow `style-src 'self'; img-src 'self'` policy.

**Limitations:** Typography varies modestly by operating system. Local assets increase repository size and require direct privacy, licensing, and metadata review.

**Review trigger:** A brand or accessibility requirement that the system stack and current local formats cannot satisfy. Any new asset needs provenance, privacy, size, CSP, and offline-failure review.

## ADR-005 — GitHub Pages branch publishing

**Status:** Accepted; remote creation and deployment pending Phases 7–8

**Context:** The repository already contains deployment-ready static files and needs no custom build. GitHub Pages supports publishing a selected branch and folder while GitHub operates the deployment infrastructure.

**Decision:** Publish from `main` and `/(root)` using **Deploy from a branch**. Keep `.nojekyll` in the root and inspect the GitHub-managed deployment run.

**Alternatives considered:** A custom GitHub Actions workflow, a `gh-pages` build branch, another static host, a virtual private server, or self-hosting.

**Consequences:** Source and publication content remain the same reviewed files, with no project-authored deployment code or third-party action. GitHub still runs a managed Pages workflow.

**Limitations:** GitHub controls build/deployment mechanics, origin service, TLS, availability, and available response headers. Deployment and live behavior are not complete until observed and recorded.

**Review trigger:** A required build step, unsupported file behavior, material availability requirement, or need for project-controlled response headers.

## ADR-006 — Meta-delivered CSP with documented limitations

**Status:** Accepted, implemented, and locally tested

**Context:** A restrictive policy provides defense in depth against accidental unsafe HTML, but the selected Pages architecture does not expose arbitrary project-controlled HTTP response headers.

**Decision:** Put the same exact CSP meta element immediately after the charset declaration in every HTML page: deny by default, allow only same-origin CSS and images, and deny scripts, connections, forms, objects, and base changes. Add `no-referrer` separately.

**Alternatives considered:** No CSP, a permissive policy, a CSP injected by an additional proxy/hosting layer, or migration to a host with configurable headers.

**Consequences:** Supported resource restrictions take effect without new infrastructure. Static checks freeze the policy, and a local browser probe has observed representative blocks.

**Limitations:** Meta CSP cannot enforce `frame-ancestors`, `sandbox`, or reporting directives. The project cannot independently set other response headers, and browser/live tests remain necessary. Clickjacking is accepted while the site is noninteractive.

**Review trigger:** Any script, external resource, form, API call, embedded content, sensitive interaction, material scanner finding, or available native Pages header configuration.

## ADR-007 — No custom domain or additional edge infrastructure

**Status:** Accepted; deployment pending

**Context:** The `saibshuvro.github.io` address matches the repository identity and avoids a separate DNS, registrar, proxy, and certificate-management surface.

**Decision:** Use the GitHub-provided user-site domain with no custom domain, Cloudflare layer, reverse proxy, Nginx server, or alternate CDN.

**Alternatives considered:** A purchased domain pointed directly at Pages, a proxy that injects headers, or another hosting/edge provider.

**Consequences:** Ownership and recovery dependencies stay small, and there is no custom DNS or proxy configuration to secure. The project accepts the Pages header boundary instead of adding infrastructure for scanner scores.

**Limitations:** The project has no independent domain identity, edge policy, configurable headers, or provider failover. GitHub account and service availability remain central dependencies.

**Review trigger:** A concrete identity, portability, header, legal, or availability requirement whose benefit exceeds the added registrar, DNS, certificate, and proxy responsibilities.

## ADR-008 — No custom GitHub Actions workflow

**Status:** Accepted and implemented in source; managed Pages run pending deployment

**Context:** The site needs no build, test environment, package installation, secret, or custom deployment step. A workflow file would add executable automation and permission review without solving a current problem.

**Decision:** Keep `.github/workflows/` absent. Use the GitHub-managed Pages deployment produced by branch publishing and review actual repository Actions permissions after remote creation.

**Alternatives considered:** A custom Pages workflow, third-party Actions for linting/security scans, or a general CI pipeline.

**Consequences:** There is no project-authored workflow supply chain, token-bearing automation, or action-version maintenance. Local verification stays explicit and auditable.

**Limitations:** Checks do not run automatically on GitHub. Branch publishing still creates a GitHub-managed Actions run, and GitHub operates that code and its permissions.

**Review trigger:** Multiple maintainers, frequent unsafe drift, a mandatory build, or a check that demonstrably needs server-side automation. Any workflow proposal needs least-privilege and pinned-dependency review.

## ADR-009 — SSH-signed commits and a narrow `main` ruleset

**Status:** Accepted; signing implemented locally, GitHub verification and ruleset pending Phase 7

**Context:** Content integrity depends primarily on the maintainer account and accepted Git history. The project has one maintainer and no CI status checks or mandatory review team.

**Decision:** Sign every commit and tag with a dedicated passphrase-protected Ed25519 signing key. After the public repository exists, apply an active ruleset to `main` that requires signed commits, blocks force pushes, restricts deletion, and keeps bypass access narrow. Do not add mandatory pull-request approval or unsatisfied status checks solely for appearance.

**Alternatives considered:** Unsigned commits, GPG signing, reusing the SSH authentication key, broad branch restrictions, or mandatory pull requests for a single maintainer.

**Consequences:** Current commits have valid local SSH signatures, authentication and signing keys remain separated, and future branch enforcement has a specific minimal design. GitHub `Verified` state is not claimed before the first push.

**Limitations:** A valid signature proves key use, not reviewer approval or benign content. A compromised key/account or authorized administrator may still cause harm, and ruleset enforcement depends on GitHub configuration and bypass permissions.

**Review trigger:** Maintainer or ownership change, key loss/compromise, an unverified commit, ruleset bypass, collaborator addition, or a need for independent review.

## ADR-010 — Public verification documents without sensitive evidence

**Status:** Accepted and implemented for current documentation

**Context:** Public security reasoning improves reviewability, but screenshots and raw outputs can expose account menus, email details, local paths, session identifiers, tokens, or recovery material.

**Decision:** Publish architecture, threats, decisions, response procedures, commands, dates, versions, expected/observed outcomes, and redacted summaries. Never commit secrets, recovery codes, private procedures, raw account exports, session data, private keys, or evidence that creates new risk.

**Alternatives considered:** No public security documentation, raw tool-output archives, private-only evidence, or screenshots of every setting.

**Consequences:** Reviewers can evaluate the security model without gaining sensitive operational material. Some settings rely on dated maintainer attestations instead of publicly reproducible raw evidence.

**Limitations:** Redaction can omit useful diagnostic context, and public documents can become stale. Documentation is evidence of reasoning and observation, not proof against compromise.

**Review trigger:** Any evidence addition, incident, new tool, account-setting record, architecture change, or report that current redaction prevents meaningful independent review.
