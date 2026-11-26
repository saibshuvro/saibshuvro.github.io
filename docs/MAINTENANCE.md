# Security maintenance

## Purpose and ownership

This runbook keeps the portfolio's small security model current without adding a
workflow, dependency, monitoring service, or recurring public-data collection. The
repository maintainer owns each review and records only sanitized conclusions.

The live site has no application runtime to patch. Maintenance therefore focuses on
account access, repository and Pages controls, signed history, the frozen static-site
constraints, public content, live browser behavior, and the accuracy of the security
documents.

## Cadence

| Review | Due | Next due from the initial baseline |
| --- | --- | --- |
| Quarterly security review | Every three months after the last completed review | `2027-02-26` |
| Defacement tabletop | At least annually after the last completed exercise | `2027-11-26` |
| Change-triggered review | Before or immediately after the triggering change, as risk requires | Not calendar based |

A private calendar reminder is sufficient. The project intentionally does not add a
scheduled GitHub Action merely to prove that a checklist exists. If a due date is
missed, perform the review as soon as practical, record the actual date, and set the
next date from that completion.

## Quarterly procedure

### 1. Account and recovery

- Review GitHub active sessions and the security log for unexpected activity.
- Review SSH and signing keys, personal access tokens, OAuth applications, and
  GitHub Apps; remove anything no longer recognized or required.
- Confirm GitHub and associated-email recovery remains usable without copying
  recovery codes, phone numbers, private addresses, or device details into evidence.

### 2. Repository and deployment controls

- Confirm the repository is still public and owned by the intended personal account.
- Confirm `main-integrity` remains active for the default branch with no bypass actor
  and the signature, deletion, and non-fast-forward rules.
- Confirm default Actions token permissions remain read-only, pull-request creation
  and approval remain disabled, and no unexpected workflow file or run exists.
- Review secret-scanning alerts and push-protection state without exporting suspected
  secret values.
- Confirm Pages still publishes from `main` and `/(root)`, HTTPS remains enforced,
  and recent managed deployments correspond to expected signed commits.

### 3. Local source and history

- Confirm the expected remote, clean worktree, and intended branch before review.
- Run the dependency-free static verifier:

  ```sh
  ./scripts/check.sh
  ```

- Run the current official Gitleaks release against all reachable Git history and
  record its version, commit count, scope, and redacted finding count:

  ```sh
  gitleaks git --log-opts='--all' --no-banner --redact .
  ```

- Review the portrait and text for intentional public content and accidental metadata
  or personal-information drift.
- Compare the actual architecture with the threat model, decisions, incident plan,
  security policy, and this runbook.

### 4. Live behavior

- Load the HTTPS homepage and a new unique nonexistent path.
- Confirm the homepage, same-origin CSS and portrait, custom 404, and home link work.
- Inspect responsive behavior, keyboard focus, the browser console, and network
  activity for unexpected errors, third-party requests, or mixed content.
- Recheck the HTTP-to-HTTPS redirect and selected response headers when GitHub Pages
  behavior or hosting configuration may have changed.

### 5. Record and disposition

Create a dated file under `docs/verification/` containing:

- date, timezone, operator, repository tip, live URL, and relevant tool versions;
- each expected control, its observed state, and pass/fail/not-applicable result;
- material findings, corrective action, accepted deviations, and next review date;
- a statement that credentials, recovery material, raw alerts, session data, and
  unrelated screenshots were excluded.

An unchanged setting may reference a same-day or sufficiently recent source record;
do not generate duplicate screenshots or raw exports merely for volume. A failed or
uncertain control is not marked complete until corrected or explicitly accepted with
an owner and review date.

## Change-triggered review

Repeat the relevant release phases immediately when:

- identity text, links, portrait, HTML pages, or resource types change;
- a script, dependency, form, external asset, custom domain, hosting layer, workflow,
  collaborator, or data-collection feature is proposed;
- GitHub materially changes Pages, Actions, rulesets, signature verification, or
  secret protection;
- a security alert, suspicious account event, deployment mismatch, secret exposure,
  or accidental personal-data publication occurs; or
- repository ownership, maintainership, signing keys, or recovery methods change.

A change-triggered review is scoped to the actual risk, but architecture-changing
proposals must revisit the threat model, security decisions, CSP, hosting constraints,
and incident procedures before implementation.

## Annual defacement exercise

Use a hypothetical scenario; never deface the live site or add a public probe. Walk
through detection, severity, containment, eradication, recovery, verification, and
post-incident review using `INCIDENT_RESPONSE.md`. Confirm:

- the last trusted signed commit can be identified;
- private account/email recovery instructions or material remain available outside
  the repository;
- the public reporting address is monitored;
- the public playbooks still match the current GitHub and Pages configuration; and
- sanitized lessons, owners, and follow-up dates are recorded without private
  procedures or credentials.

Escalate a defacement from SEV-2 to SEV-1 when evidence indicates account takeover,
signing-key compromise, active malicious content with serious impact, or another loss
of the primary trust boundary.

## Evidence retention and privacy

Public evidence demonstrates that a review occurred; it is not the incident log or a
backup of account settings. Keep credentials, recovery data, provider case details,
and compromise-sensitive notes in the owner-controlled private location described by
the incident plan. Delete temporary browser profiles, scanner reports, archives, and
screenshots after their sanitized conclusions are recorded.
