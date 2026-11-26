# Annual defacement exercise — 2026-11-26

## Exercise boundary

This was a discussion-based exercise. No live content, account setting, credential,
workflow, or deployment was changed. The scenario assumed a visitor reports that the
homepage contains an unauthorized link and altered biography while the maintainer has
access to a trusted local clone.

- Exercise date and timezone: `2026-11-26`, Asia/Dhaka
- Exercise owner: Saib Saleh Nabil
- Facilitator: Codex
- Public procedure reviewed: `docs/INCIDENT_RESPONSE.md`
- Last trusted signed commit at exercise start: `cc5b8bc9bac724143c77dbf31f731c38d6f6120d`
- Next annual exercise due: `2027-11-26`

## Walkthrough

| Stage | Decision and action walked through | Expected evidence or exit condition |
| --- | --- | --- |
| Detection | Reproduce from a clean browser without interacting with the unauthorized link; record time, URL, minimal description, visible deployed state, and reporter path | Defacement distinguished from a local cache/extension issue without publishing unrelated browser data |
| Triage | Begin at SEV-2 for confirmed unauthorized public content; escalate to SEV-1 if account takeover, signing-key compromise, or serious active visitor harm appears | Scope identifies account, workstation, repository, deployment, or platform involvement |
| Containment | If account trust is uncertain, recover GitHub and associated email first from a trusted device; revoke unknown access and stop publication when safe | Harmful content is no longer served or trusted access is restored before repository recovery |
| Preservation | Keep a private timestamped log and preserve the last trusted signed local history; record identifiers, never secret values | Essential facts survive without using a possibly compromised repository as the primary log |
| Eradication | Review sessions, keys, tokens, apps, security log, commits, signatures, ruleset state, Pages source, and managed runs; remove unauthorized access/configuration | Entry path and affected interval are bounded, not merely the visible page change |
| Recovery | Prefer a reviewed signed corrective/revert commit from the trusted state; rotate the signing key if confidentiality is uncertain; restore intended repository and Pages settings | Correct source is accepted by the ruleset and deployed from the expected commit |
| Verification | Run static and full-history secret checks; verify signatures/ruleset/deployment; inspect HTTPS, redirect, homepage, unique 404, console, network, and headers | Public origin matches the reviewed signed state with no unexpected request or error |
| Follow-up | Build a sanitized timeline, update affected documents/controls, assign owners and dates, and monitor proportionately | Root cause and lessons are captured without exposing recovery procedures |

## Readiness checks

- The current trusted commit was identifiable locally and in the documented Pages
  deployment chain.
- The public incident plan covered defacement, account compromise, repository change,
  credential exposure, personal-data exposure, and Pages failure without requiring a
  new playbook.
- The response distinguishes a routine signed correction from the cases that require
  account recovery, credential rotation, or history cleanup.
- The public reporting policy names the professional reporting address and a five-
  business-day best-effort acknowledgment target.
- The owner confirmed the public reporting address is actively monitored for security
  reports.
- The owner confirmed private GitHub and associated-email recovery material remains
  available outside the repository.
- Private recovery details, codes, key material, device data, and provider case paths
  were not requested or recorded in this exercise.

## Lessons

1. The most important first branch is whether GitHub/account trust remains intact;
   repository repair is unsafe until that is known.
2. The signed local clone provides a recovery reference, while signatures alone do
   not prove that content was reviewed or benign.
3. A new signed corrective commit is the default recovery method; destructive history
   rewriting is reserved for exposed sensitive material or compromised objects.
4. Existing verification commands and live checks are sufficient for recovery; an
   automated incident workflow would add an unnecessary trusted execution surface.

No gap requiring an architectural change was identified. Conclusion: **Pass**.
