# Minimal Secure Portfolio

This repository contains Saib Saleh Nabil's minimalist portfolio and its security engineering record. The site uses semantic HTML, one local CSS file, and one privacy-processed portrait; it has no application JavaScript, backend, database, authentication, form, analytics, runtime package, build step, or third-party runtime asset. The small architecture is deliberate: the project concentrates its controls on content integrity, browser policy, account and repository security, controlled publishing, and reproducible verification.

**Live site:** Pending Phase 8 deployment. The intended address is `https://saibshuvro.github.io/`; no live-site claim is made until that origin is verified.

## Architecture

The publication tree is served as static files. `index.html` provides the portfolio, `404.html` provides the error page, `styles/main.css` contains all styling, and `assets/portrait.jpg` is the only image. An empty `.nojekyll` keeps branch publishing on the plain-file path. GitHub Pages branch publishing from `main` and `/(root)` is the accepted deployment design, but the remote repository and Pages deployment remain pending.

No visitor data is received or stored by project code. The site has no server-side component, cookies, browser storage, telemetry, or API requests. The Email link opens the visitor's configured mail client; GitHub and LinkedIn links navigate to those independent services.

## Security status

Implemented and observed locally:

- a deny-by-default meta Content Security Policy on both HTML pages;
- `script-src 'none'`, no application JavaScript, and no JavaScript files;
- same-origin-only CSS and images, with no external fonts or runtime dependencies;
- `no-referrer`, no forms, no embedded content, and no browser storage;
- a metadata-cleaned local portrait and an intentionally narrow set of public identity data;
- a dependency-free static verifier with positive and negative self-tests;
- SSH-signed Git history, with all current signatures valid under the local allowed-signers configuration; and
- a dated, sanitized owner review of GitHub authentication, recovery, sessions, credentials, integrations, public profile, and associated-email protection.

Pending before publication:

- full-history secret scanning and the Phase 7 browser release matrix;
- creation of the public repository and confirmation of GitHub's `Verified` state;
- repository ruleset, Actions permission, secret-scanning, and push-protection review;
- GitHub Pages configuration, HTTPS deployment, and live HTTP/browser verification.

See the [threat model](docs/THREAT_MODEL.md), [security architecture](docs/SECURITY_ARCHITECTURE.md), [decision records](docs/SECURITY_DECISIONS.md), and [verification guide](docs/verification/README.md) for the evidence and boundaries behind these statements.

## Local viewing

The pages use root-relative asset paths, so serve the repository root over local HTTP instead of opening the files directly. One option, when Python 3 is already installed, is:

```sh
python3 -m http.server 8000
```

Then open `http://localhost:8000/`. Python is a local convenience for previewing; it is not a project dependency or part of the deployed site.

## Static verification

Run the verifier from the repository root:

```sh
./scripts/check.sh
```

The command reads the publication tree, reports all detected violations, and exits nonzero if a frozen constraint fails. Its checks are pattern based rather than a substitute for browser tests, live HTTP inspection, secret scanning, or review of GitHub settings.

## Documentation

- [Security policy](SECURITY.md) — supported scope and responsible reporting
- [Threat model](docs/THREAT_MODEL.md) — assets, actors, threats, controls, and residual risk
- [Security architecture](docs/SECURITY_ARCHITECTURE.md) — components, trust boundaries, and flows
- [Security decisions](docs/SECURITY_DECISIONS.md) — ADR-style records for major choices
- [Incident response](docs/INCIDENT_RESPONSE.md) — public response framework and playbooks
- [Verification guide](docs/verification/README.md) — checks, evidence format, and limitations

## Known limitations

- The CSP is delivered through HTML because this GitHub Pages design does not provide project-controlled response headers. Meta CSP cannot enforce `frame-ancestors`, `sandbox`, or reporting directives, so clickjacking remains an accepted residual risk. The site has no authenticated or state-changing operation, which limits the likely impact.
- Project code cannot set headers such as `Permissions-Policy` or `X-Content-Type-Options` on GitHub Pages. Observed live headers remain pending deployment.
- GitHub operates the repository and hosting control planes. Platform compromise, administrator bypass, service outage, and large-scale denial of service are not independently preventable by this project.
- Static pattern checks reduce accidental drift but are not a complete HTML/CSS parser or proof of security.
- Public content and Git history can be copied or cached after publication. Removing later versions does not guarantee deletion from third-party copies.
- The project does not control the security, privacy, or availability of GitHub, LinkedIn, email providers, or other sites reached through outbound links.

Security reports are handled according to [SECURITY.md](SECURITY.md). No bug bounty or private reporting portal is offered.
