# Initial maintenance baseline — 2026-11-26

## Scope

This record establishes the first quarterly baseline immediately after the release
and post-deployment verification. It references the same-day Phase 6–9 evidence where
the underlying state did not change and adds a fresh full-history secret scan and
documentation-drift review. It does not represent repeated account access or browser
testing as independent evidence.

- Repository tip at review start: `cc5b8bc9bac724143c77dbf31f731c38d6f6120d`
- Live URL: `https://saibshuvro.github.io/`
- Date and timezone: `2026-11-26`, Asia/Dhaka
- Operator: maintainer-assisted Codex review
- Next quarterly review due: `2027-02-26`

## Checklist result

| Area | Evidence and observation | Result |
| --- | --- | --- |
| Account sessions and security log | Same-day sanitized owner [account review](2026-11-26-account-security-review.md) recorded the review without session or recovery details | Pass |
| Keys, tokens, OAuth applications, and GitHub Apps | Same account review recorded each category reviewed; separate Ed25519 authentication and signing roles remain documented | Pass |
| Account recovery | Owner confirmed GitHub recovery, protected associated email, and securely stored recovery codes; no recovery material is public | Pass |
| Repository visibility and ownership | Public `saibshuvro/saibshuvro.github.io` remained the expected origin | Pass |
| Ruleset and Actions permissions | Same-day [repository controls](2026-11-26-repository-controls-review.md) and [post-deployment review](2026-11-26-deployment-review.md) recorded active no-bypass signature/deletion/non-fast-forward rules and restricted Actions permissions | Pass |
| Secret Protection | Secret scanning and push protection were enabled and the owner reported no alert | Pass |
| Pages source and deployments | `main` and `/(root)` remained the source; managed run `45845247121` successfully deployed the signed Phase 9 evidence commit | Pass |
| Static verification | `scripts/check.sh` passed after the Phase 9 commit and again during this baseline | Pass |
| Live homepage, console, and network | Same-day [browser checklist](2026-11-26-browser-checklist.md) recorded correct rendering, no homepage console problem, and no unexpected or third-party runtime request | Pass |
| Unique live 404 | Same browser and [HTTP evidence](2026-11-26-http-headers.txt) recorded the custom body, CSS, home link, and actual status `404` | Pass |
| Portrait and text privacy | The approved content boundary and metadata-cleaned portrait were rechecked in the [pre-publication review](2026-11-26-pre-publication-review.md); no later site-content change occurred | Pass |
| Architecture/document drift | One stale pre-deployment sentence in `SECURITY.md` was found and corrected; a dedicated maintenance runbook and first tabletop record were added | Pass after correction |

## Full-history secret scan

- Tool: official Gitleaks `8.30.1`
- Archive verification: downloaded SHA-256 matched the release's published checksum
- Command class: `gitleaks git --log-opts='--all' --redact`
- Scope: all reachable refs, nine commits, approximately `148.66 KB`
- Result: zero findings; no allowlist, baseline, ignore rule, or bypass used
- Duration reported by tool: `231 ms`

The scanner report and binary remained temporary and are not committed. A zero-finding
pattern scan does not prove that no secret exists; it complements manual review,
GitHub push protection, and secret scanning.

## Findings and disposition

No security incident or material control failure was found. The stale deployment
statement was documentation drift, not a live-control failure, and was corrected in
this maintenance update. No new automation, dependency, service, or public personal
field was introduced.

Sensitive account output, recovery material, tokens, raw scanner payloads, session
identifiers, private procedures, and screenshots were intentionally excluded.

Conclusion: **Pass after documentation correction.**
