# Incident response

## Purpose and ownership

This public plan covers incidents affecting the portfolio's content, Git history, GitHub account relationship, deployment, approved personal information, or visitor safety. It deliberately excludes private recovery material and step-by-step account secrets.

**Incident owner:** Saib Saleh Nabil, repository maintainer

**Public reporting address:** saibsalehnabil@gmail.com

**Platform operator:** GitHub for account recovery, repository service, Actions, and Pages infrastructure

The maintainer acts as incident commander, confirms severity, authorizes containment and recovery, and maintains a sanitized public record when useful. GitHub or another provider owns remediation of failures inside its service. No alternate public incident contact is currently designated.

## Severity

| Severity | Definition | Examples | Response posture |
| --- | --- | --- | --- |
| **SEV-1 Critical** | Active or highly credible loss of the primary trust boundary with serious ongoing impact | GitHub account takeover, compromised signing key used for publication, active malicious site content, exposed high-impact credential | Act immediately from a trusted device; contain publication and access before routine work |
| **SEV-2 High** | Confirmed integrity/privacy incident with material impact but no observed full account takeover | Unauthorized commit or deployment, significant defacement, unintended sensitive personal data in public history | Contain promptly, preserve safe evidence, and complete scoped recovery before republishing |
| **SEV-3 Medium** | Contained weakness or suspected exposure with limited current impact | Unsafe HTML stopped before deployment, stale access token with no observed use, repeated deployment failure caused by configuration | Investigate and correct on a priority basis; increase severity if evidence changes |
| **SEV-4 Low** | Minor defect or transient availability issue without security impact | Cosmetic error, short provider outage, documentation mismatch | Track and repair through normal signed maintenance |

Severity is reassessed when new evidence appears. When uncertain between two levels, begin with the higher response posture until impact is bounded.

## Handling principles

1. Protect people and stop ongoing harmful publication before optimizing evidence quality.
2. Use a known-clean device and network path when account or workstation compromise is plausible.
3. Preserve only evidence that is safe and necessary; never copy a secret into an issue, commit, chat, or public note.
4. Treat commit signatures as one integrity signal, not proof that content is benign.
5. Prefer a new signed corrective commit over rewriting history unless sensitive data or a compromised object makes rewriting necessary.
6. Coordinate provider-owned failures through the provider's official support or security process.
7. **Deleting an exposed secret from a file or Git commit is insufficient. Revoke or rotate it, then investigate use and copies.**

## Safe out-of-band notes

If GitHub or the repository is suspected to be compromised, do not use repository issues, discussions, Actions artifacts, or commits as the primary incident log. Keep a minimal timestamped log outside GitHub in an owner-controlled encrypted local location or other previously approved private channel. Record:

- date/time and timezone;
- reporter and contact path without unnecessary personal data;
- observed URLs, commit identifiers, deployment identifiers, and sanitized error text;
- actions taken, by whom, and the observed result;
- credentials or sessions revoked by type, never by value; and
- the last known trusted signed commit.

Real recovery codes, phone numbers, private email recovery paths, tokens, private keys, device details, and provider case secrets do not belong in this document or any public post-incident record. If email is also suspect, use GitHub's official recovery/support path from a trusted device rather than the compromised mailbox.

## Response lifecycle

### 1. Detection and triage

- Confirm the report using the least invasive method available.
- Record first-observed time, affected URL/file/commit, and current deployment state.
- Decide whether account, signing key, local workstation, repository, deployment, personal data, or provider service may be affected.
- Assign severity and expand scope cautiously; avoid executing untrusted page content or proof-of-concept files.

### 2. Containment

- Stop ongoing exposure or publication when project access is trustworthy.
- If account compromise is plausible, secure/recover the account and associated email before relying on repository changes.
- Revoke suspicious sessions, tokens, applications, and keys through official provider interfaces.
- Preserve the last trusted local signed history and avoid destructive cleanup before essential facts are recorded.

### 3. Eradication

- Remove unauthorized content, access, workflow/configuration, or compromised credentials.
- Identify the entry path rather than treating only the visible symptom.
- Review account security log, sessions, keys, tokens, applications, repository settings, ruleset bypasses, workflow runs, and deployment source as relevant.
- Scan the full history and local environment when credential or source compromise is possible.

### 4. Recovery

- Restore content from the last trusted signed state or create a reviewed signed corrective commit.
- Reapply and verify repository, Actions, security-analysis, and Pages settings.
- Re-enable publication only after static checks and incident-relevant browser/live checks pass.
- Rotate the signing key if confidentiality is uncertain; do not treat registration of a new public key as sufficient without removing trust in the old one.

### 5. Verification

- Run `./scripts/check.sh` from a clean working tree or equivalent clean copy.
- Verify local and GitHub signature state, expected remote, branch, ruleset, and deployed commit as applicable.
- Inspect homepage, a unique 404 path, console, network activity, HTTPS redirects, and relevant headers after deployment.
- Confirm revoked credentials no longer work without placing their values in logs.
- Continue monitoring for recurrence at a frequency proportionate to severity.

### 6. Post-incident review

- Build a concise timeline and identify root cause, contributing controls, missed signals, and recovery friction.
- Update the threat model, decisions, verifier, account checklist, and response plan where evidence justifies change.
- Record only sanitized conclusions publicly.
- Set a follow-up review date and close the incident only after corrective actions are verified.

## Scenario playbooks

### Website defacement

1. Capture the URL, time, deployed commit, and a minimal safe description; avoid publishing a screenshot containing unrelated account or browser data.
2. Determine whether the page comes from the expected repository commit or from a platform/cache issue.
3. If repository control is intact, stop Pages or restore trusted content using a reviewed signed commit. If control is uncertain, handle account compromise first.
4. Inspect recent commits, signatures, ruleset bypasses, workflow/deployment runs, Pages source, account events, and remote configuration.
5. Remove unauthorized access or configuration, recover the trusted state, rerun verification, and confirm the public origin from a clean browser session.

### GitHub account compromise

1. Use a trusted device to invoke GitHub's official account-recovery and support processes.
2. Secure the associated email account and recovery channels; assume repository settings alone are insufficient.
3. Revoke unknown sessions, tokens, SSH keys, signing keys, OAuth applications, and GitHub Apps. Preserve identifiers and timestamps, not secret values.
4. Inspect every owned repository and recent security-log event, not only this portfolio.
5. Treat the signing key as compromised if its confidentiality or agent access is uncertain. Replace it and reassess commits made during the exposure window.
6. Restore project settings/content, verify the deployed commit, and monitor for recurrence.

### Malicious or accidental repository change

1. Prevent the affected commit from deploying or temporarily stop publication when it is already live.
2. Compare the change, author, signature, parent history, and deployment source with the last trusted signed commit.
3. Determine whether the event was a review failure, credential misuse, ruleset bypass, or account compromise.
4. Prefer a new signed revert/corrective commit so the event remains auditable. Rewrite public history only when sensitive material or compromised objects make that necessary.
5. Rerun static, secret, metadata, and browser checks appropriate to the change; verify the final Pages deployment.

### Credential exposure

1. Identify the credential type and provider without copying its value.
2. Revoke or rotate it immediately through the provider. Deleting the text or making the repository private does not invalidate the credential or remove existing copies.
3. Review provider logs and permissions for unauthorized use, and expand to account compromise response when indicated.
4. Search the entire Git history, branches, tags, artifacts, issues, caches, forks, and local outputs that may contain the value.
5. Clean history only after rotation and impact assessment; coordinate public-history cleanup and notifications where useful.
6. Record the credential type, exposure window, rotation time, and result in private sanitized notes—never the old or new value.

### Accidental personal-information publication

1. Remove the page or disable publication promptly when continued exposure creates harm.
2. Identify affected people, fields, assets, commits, caches, archives, and search results without reproducing the information unnecessarily.
3. Correct current source and decide whether history rewriting and provider/cache removal requests are proportionate.
4. Notify the affected person privately when appropriate and avoid amplifying the data through public incident details.
5. Reassess content approval, metadata processing, verification evidence, and publication-boundary controls before republishing.

### Pages outage or deployment failure

1. Preserve the local signed source; do not make speculative content changes to solve a provider outage.
2. Check GitHub's service status, the Pages settings, managed workflow run, source branch/folder, and expected commit.
3. Distinguish a GitHub outage from a repository/configuration failure. Do not repeatedly rerun deployments without understanding the failed step.
4. Correct project configuration through a signed commit or settings change only when evidence identifies the cause.
5. After recovery, confirm HTTPS, redirects, homepage assets, unique-path 404 behavior, console/network state, and deployment-to-commit mapping.

## Exercises and maintenance

Walk through a hypothetical defacement at least annually after deployment. Confirm that the last trusted signed commit can be identified, private recovery instructions remain available outside this repository, the reporting address is monitored, and the public procedure still matches GitHub's current controls. Record the exercise date and sanitized lessons without disclosing recovery material.
