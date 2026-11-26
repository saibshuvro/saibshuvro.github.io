# Account security review — 2026-11-26

## Scope and evidence policy

This record is a sanitized maintainer attestation for the GitHub account and associated professional email account used by the portfolio. The review intentionally retains no recovery codes, authentication secrets, phone numbers, session data, token values, key material, application inventory, sensitive security-log entries, screenshots, or private recovery procedures.

## Owner-confirmed review

| Control | Result |
| --- | --- |
| GitHub passkey and/or strong two-factor authentication | Confirmed protected |
| Associated email account | Confirmed equivalently protected |
| Recovery codes | Confirmed stored in a secure approved location; location and values not recorded |
| GitHub active sessions and security log | Review completed; no unresolved blocker reported |
| SSH authentication and signing keys | Review completed; no key material recorded |
| Personal access tokens | Review completed; no token inventory or values recorded |
| Authorized OAuth applications | Review completed; no application inventory recorded |
| Installed GitHub Apps | Review completed; no application inventory recorded |
| Public GitHub profile | Review completed; current Facebook link explicitly retained by owner |

Only credentials or integrations confirmed unnecessary were candidates for removal. This evidence does not claim that a public checklist can independently prove private account state.

## Signing and local repository observations

- All four local project commits have valid SSH signatures under the repository's local allowed-signers configuration.
- The dedicated public signing key was previously confirmed on the correct GitHub account.
- Repository-local automatic commit and tag signing remains configured.
- Vigilant mode remains disabled by owner choice after review of its account-wide semantics. This does not change the requirement that every project commit be signed.
- No Git remote is configured, and no public push occurred during Phase 6.
- SSH is the selected authentication method for the future `origin` remote; the remote itself remains pending Phase 7.

## Confirmed repository identity

- Owner: `saibshuvro`
- Repository: `saibshuvro.github.io`
- Intended source URL: `https://github.com/saibshuvro/saibshuvro.github.io`
- Intended site URL: `https://saibshuvro.github.io/`

The intended endpoints remain pending. Phase 7 confirms the repository identity before adding any remote or making the first public push.

## Remaining boundaries

- GitHub's `Verified` state cannot be observed until the first reviewed public push.
- The `main` ruleset, Actions permissions, secret-scanning settings, push protection, and Pages configuration are repository controls and remain pending Phase 7 or later.
- A repository administrator may be able to modify or bypass protections depending on the actual GitHub plan and configuration. Rulesets do not replace account security.
- GitHub operates the repository, identity, deployment, and hosting control planes.

## Review outcome

Phase 6 account, recovery, access, signing-readiness, public-profile, and remote-method decisions were confirmed without committing sensitive evidence. No unresolved condition was reported that requires publication to stop before the Phase 7 release gate.
