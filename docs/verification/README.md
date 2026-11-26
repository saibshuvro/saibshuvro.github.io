# Security verification

This directory defines how the project tests its frozen constraints and records evidence without turning sensitive account data into public artifacts. Static source checks, browser behavior, release checks, GitHub settings, and live HTTP behavior are separate evidence classes; success in one class does not imply success in another.

## Current status

| Evidence class | Status on 2026-11-26 | Notes |
| --- | --- | --- |
| Static source verifier | Complete | Valid site passes under `sh` and `dash`; fourteen negative fixtures fail as expected |
| Local CSP capability probe | Complete | Disposable Chromium-family probe observed representative script, style, image, and base-policy blocks |
| Portrait privacy inspection | [Complete](2026-11-26-pre-publication-review.md#portrait-and-content-review) | Release-gate marker and visual review passed |
| GitHub account and email review | [Complete by owner attestation](2026-11-26-account-security-review.md) | Sanitized record retained; no sensitive settings evidence committed |
| Full browser release matrix | [Complete locally](2026-11-26-pre-publication-review.md#browser-matrix) | Chromium, Firefox, keyboard, zoom, failure states, 404, console, and network checks passed |
| Full-history secret scan | [Pre-evidence scan complete](2026-11-26-pre-publication-review.md#secret-scanning) | The exact signed public commit receives one more full-history scan immediately before first push |
| GitHub repository/settings review | Pending Phases 7–9 | No public remote exists yet |
| Pages deployment and HTTPS | Pending Phases 8–9 | The intended live URL is not treated as deployed |
| Live HTTP, browser, and 404 evidence | Pending Phase 9 | Requires a known deployed signed commit |

## Static verification

Run from the repository root:

```sh
./scripts/check.sh
```

The script resolves the repository from its own location, reads project files without modifying them, reports all detected issues, and exits with status `0` only when every check passes.

It checks:

- required website, verification, and public documentation files;
- every HTML document in the publication tree;
- the exact frozen meta Content Security Policy on every HTML page;
- `no-referrer`, document-language, and viewport metadata;
- absence of scripts, inline event handlers, `javascript:` URLs, inline CSS, forms, embedded media, frames, plug-in content, and base elements;
- absence of insecure HTTP references and remote resource dependencies;
- absence of CSS imports, external/protocol-relative CSS URLs, and JavaScript files;
- existence of referenced local CSS and image files, including root-relative and relative paths;
- the four approved homepage navigation labels;
- the exact approved homepage tagline, present once; and
- nonempty alternative text and explicit dimensions on the portrait.

Outbound HTTPS links in anchor elements are permitted. Resource checks target loading attributes and `<link>` elements, so profile navigation is not mistaken for a runtime dependency.

Supporting Phase 7 static checks remain separate because they require purpose-specific tools or judgment:

- full-history Gitleaks scanning with the installed version recorded;
- review of every committed path and Git object intended for publication;
- signature verification for every commit;
- portrait metadata and dimensions reinspection; and
- manual confirmation that all public personal information is intentional.

### Verifier self-test record

On 2026-11-25, the valid site passed syntax and execution checks under both `sh` and `dash`, including invocation from outside the repository. Disposable copies were changed one at a time to introduce:

1. a script element;
2. an inline event handler;
3. inline CSS;
4. a remote image;
5. an insecure HTTP link;
6. a missing root-relative local stylesheet;
7. a missing relative local stylesheet;
8. a missing CSP on `404.html`;
9. a missing referrer policy on `404.html`;
10. a CSS import without whitespace after `@import`; and
11. a multiline remote stylesheet.

All eleven fixtures exited nonzero and identified the expected violation. The disposable copies were removed after the test.

On 2026-11-26, three additional disposable fixtures exercised the approved-tagline rule: one removed the tagline, one duplicated it, and one placed the exact text in a `div` rather than its required paragraph. All three exited nonzero and identified the expected violation. The unchanged complete candidate passed from the same disposable copy without a `.git` directory, and all fixtures were removed.

## Browser verification

### Completed local CSP probe

A disposable local Chromium-family test on 2026-11-25 observed the frozen policy reject:

- inline JavaScript;
- a same-origin external script;
- inline `<style>` content;
- a `style` attribute;
- a cross-origin image; and
- a hostile `<base>` element.

The browser security log reported violations of `script-src 'none'`, `style-src 'self'`, `img-src 'self'`, and `base-uri 'none'`. The disposable probe was outside the repository and was removed. Its exact browser version was not retained, so the dated Phase 7 release matrix repeated policy tests in Chrome `158.0.8127.36` rather than treating the earlier probe as final browser evidence.

### Completed pre-publication browser matrix

The dated pre-publication review records expected and observed behavior for:

- Chromium-family desktop and mobile-sized views;
- Firefox desktop and mobile-sized views;
- keyboard-only navigation and visible focus;
- 200% zoom and narrow widths without horizontal overflow;
- missing/blocked portrait and missing/blocked CSS behavior;
- the custom 404 through the local test method;
- console review for unexpected CSP/resource errors;
- network review for unexpected third-party requests; and
- disposable negative CSP probes for scripts, inline style, and API connections.

Do not add probes to committed source or the public site.

### Pending post-deployment browser checks

After Pages deployment, repeat the homepage, responsiveness, keyboard, console, network, and custom-404 checks against the HTTPS origin. Confirm the browser sees the meta CSP and does not require an exception. A live check must name the URL and deployed commit.

## Live HTTP verification

Live checks are pending until Phase 8 establishes a deployed site. Representative Phase 9 commands are:

```sh
curl -I https://saibshuvro.github.io/
curl -I -L http://saibshuvro.github.io/
curl -sS -D - -o /dev/null https://saibshuvro.github.io/
```

Record:

- UTC timestamp and local date;
- tested URL and deployed commit identifier;
- tool version;
- status/redirect chain and final canonical URL;
- relevant response headers;
- same-origin loading of CSS and portrait;
- unique nonexistent path and observed 404 status/content; and
- expected versus observed result.

HEAD and GET can behave differently, so retain both when results differ. HTTP headers cannot prove enforcement of an HTML meta CSP; browser inspection and disposable local negative tests provide that evidence.

## Evidence filenames and format

Use ISO 8601 calendar dates (`YYYY-MM-DD`) and lowercase descriptive suffixes:

```text
docs/verification/
├── README.md
├── YYYY-MM-DD-http-headers.txt
├── YYYY-MM-DD-redirect-check.txt
├── YYYY-MM-DD-browser-checklist.md
└── YYYY-MM-DD-deployment-review.md
```

Add a short differentiator only when more than one record of the same type exists on one date, for example `2026-11-25-browser-checklist-firefox.md`. Do not use `latest` as the only date indicator.

Each evidence file should include:

- date, timezone, and operator;
- tested target and commit identifier;
- tool/browser name and version when useful;
- prerequisites and command or manual steps;
- expected result, observed result, and pass/fail conclusion;
- known limitations or deviations; and
- a statement that sensitive output was omitted or redacted.

## Redaction and evidence safety

- Keep credentials, tokens, private/signing keys, recovery codes, cookies, authorization headers, and session identifiers out of commands and captured output.
- Do not commit screenshots containing account menus, private recovery information, unrelated tabs, browser profiles, or security-log details.
- Replace a sensitive value with a typed marker such as `[REDACTED SESSION IDENTIFIER]`; do not preserve a prefix or suffix unless it is demonstrably safe and necessary.
- Prefer a concise manual attestation for account settings over raw exports or screenshots.
- Record secret-scanner findings by tool version, scope, redacted result, and disposition. Never paste a suspected secret into evidence.
- Store incident notes outside GitHub when GitHub compromise is plausible.

## Interpretation and limitations

Pattern-based static checks are defense in depth, not a full HTML/CSS parser or proof of security. Browser probes demonstrate behavior in tested versions and conditions, not all browsers. Secret scanners do not recognize every credential format. A valid signature proves use of a key, not that content was reviewed or safe.

Third-party scanner scores are advisory. A low header score does not by itself justify adding a proxy, custom domain, workflow, or hosting provider. GitHub Pages header constraints—especially the inability to set a project-controlled `frame-ancestors` policy—are documented in the [architecture](../SECURITY_ARCHITECTURE.md), [threat model](../THREAT_MODEL.md), and [ADR-006](../SECURITY_DECISIONS.md#adr-006--meta-delivered-csp-with-documented-limitations). Reconsider the architecture only when a concrete requirement or material risk outweighs the new infrastructure and maintenance surface.
