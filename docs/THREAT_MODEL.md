# Threat model

## Status and scope

This model covers the portfolio source, local Git history, intended public GitHub repository, GitHub-managed Pages deployment, the maintainer account as it relates to this project, and visitors loading the site. The assessment reflects the local release state on 2026-11-26: the website and local verification controls exist, while account review, public repository protections, deployment, and live verification remain pending later phases.

The model protects the project from realistic mistakes and unauthorized publication; it does not assert control over GitHub's infrastructure or a visitor's device.

## Assumptions

- The portfolio publishes only information the owner has approved for public release.
- The intended remote is the personal public repository `saibshuvro/saibshuvro.github.io`.
- GitHub Pages branch publishing uses `main` and `/(root)` with no custom domain or custom workflow.
- The maintainer remains the only authorized project administrator unless this document is revised.
- Local signing keys and account-recovery material remain outside the repository.
- GitHub, the email provider, browsers, and network operators perform their own security responsibilities.

## Protected assets

| Asset | Security objective | Consequence of loss |
| --- | --- | --- |
| Published website content | Integrity and authenticity | Defacement, malicious links, or reputational harm |
| Git history and source | Integrity and availability | Loss of a trusted recovery point or publication of unsafe content |
| GitHub account | Confidentiality and integrity | Repository takeover and unauthorized deployment |
| Signing private key | Confidentiality | Fraudulent commits that appear attributable to the maintainer |
| Deployment configuration | Integrity | Publication from an unintended branch or commit |
| Approved personal information | Privacy and accuracy | Unwanted exposure, stale identity data, or impersonation risk |
| Visitor experience | Safe browsing and availability | Exposure to malicious content or inability to reach the portfolio |
| Verification evidence | Integrity without sensitive content | False assurance or leakage through logs and screenshots |

## Actors

- **Maintainer:** owns content, local keys, repository settings, response decisions, and review evidence.
- **Visitor:** reads public content and may follow outbound links; no project authentication or state exists.
- **Security reporter:** reports a suspected weakness through the public contact address.
- **Opportunistic attacker:** seeks account access, defacement, credential leakage, or abuse of trusted links.
- **GitHub:** operates repository, identity, Actions, ruleset, and Pages control planes.
- **External providers:** operate email, LinkedIn, browsers, networks, and linked destinations.

## Trust boundaries

1. **Local workstation boundary:** source, the Git working tree, SSH agent, and private signing key meet local tools.
2. **GitHub account boundary:** credentials, sessions, recovery methods, keys, tokens, and authorized applications govern administrative access.
3. **Repository boundary:** signed local history becomes public GitHub state; rules and permissions govern accepted changes.
4. **Deployment boundary:** GitHub's managed Pages workflow turns repository content into hosted content.
5. **Internet/browser boundary:** visitors receive GitHub-hosted responses and the project-controlled HTML policy; outbound links cross into unrelated services.

## Risk method

Likelihood and impact use a three-level qualitative scale:

- **Low:** requires unusual preconditions, or produces limited and readily reversible harm.
- **Medium:** plausible during normal project operation, or causes contained privacy, integrity, or availability harm.
- **High:** credible without unusual conditions, or enables account takeover, secret compromise, persistent malicious publication, or serious reputational harm.

Priority is derived from the following matrix:

| Likelihood \ Impact | Low | Medium | High |
| --- | --- | --- | --- |
| Low | Low | Low | Medium |
| Medium | Low | Medium | High |
| High | Medium | High | Critical |

Ratings describe residual exposure in the current pre-publication state. Pending controls do not reduce a rating until they are observed.

## Threat analysis

| ID | Scenario | Likelihood / impact / priority | Preventive controls | Detective controls | Recovery controls and owner |
| --- | --- | --- | --- | --- | --- |
| T-01 | GitHub account compromise permits repository or Pages changes. | Medium / High / **High** | Dedicated signing key exists locally. Phase 6 account and email hardening, session/key/token/app review, and offline recovery review are pending. | Local signature verification exists; GitHub security-log review and GitHub `Verified` checks are pending. | Use GitHub account recovery, revoke unauthorized access, rotate affected credentials, inspect history and deployments, and restore a trusted signed commit. **Owner:** maintainer; GitHub operates account recovery. |
| T-02 | An unauthorized, malicious, or accidental repository change reaches `main`. | Medium / High / **High** | Current local commits are SSH-signed. A signed-commit, no-force-push, no-deletion ruleset remains pending remote creation. | `check.sh` detects frozen source violations; manual diff review exists. Remote audit, ruleset review, and deployment-to-commit comparison remain pending. | Stop deployment, identify the last trusted signed commit, revert through a new signed commit, and review access. Do not erase evidence before preserving what is safe. **Owner:** maintainer. |
| T-03 | A credential or secret is committed or appears in verification evidence. | Medium / High / **High** | The architecture requires no runtime secret; private keys and account material are excluded; `.gitignore` blocks narrow local clutter; evidence rules prohibit sensitive output. | Manual review exists. Full-history Gitleaks and GitHub secret-scanning review remain pending Phase 7. Neither scanner is assumed complete. | Revoke or rotate the credential first, assess use and exposure, clean history when warranted, and review copies. Deletion alone is insufficient. **Owner:** credential owner and maintainer. |
| T-04 | A dependency or third-party resource introduces supply-chain content. | Low / High / **Medium** | No runtime packages, build tools, application JavaScript, external fonts, third-party images, embeds, or custom Actions exist. CSP restricts CSS and images to the same origin. | `check.sh` rejects remote resource dependencies, JavaScript files, imports, and external CSS URLs; live network review is pending. | Remove the component, restore the frozen static architecture, reassess any downloaded content, and update decision records before reintroduction. **Owner:** maintainer. |
| T-05 | Portrait metadata reveals location, device, software, or other unintended information. | Low / Medium / **Low** | The approved portrait was re-exported and stripped before its first commit; the original remains outside Git history. | Post-processing inspection found no common EXIF, XMP, GPS, device, software, ICC, comment, or thumbnail markers; Phase 7 repeats inspection. | Replace the asset in a signed commit, evaluate Git history and caches, and request removal where practical. Public copies may persist. **Owner:** maintainer. |
| T-06 | Unsafe HTML introduces script execution, external content, forms, connections, or embedded objects. | Medium / Medium / **Medium** | No JavaScript or inline CSS is shipped. The identical meta CSP denies scripts, connections, forms, objects, base changes, and all unspecified resource types. | `check.sh` scans every HTML page; disposable static fixtures and a local browser CSP probe rejected representative violations. The Phase 7 browser matrix and live review remain pending. | Revert or repair through a signed commit, rerun static and browser checks, and verify the deployed commit after publication. **Owner:** maintainer. |
| T-07 | GitHub Pages outage or failed deployment makes the portfolio unavailable. | Medium / Medium / **Medium** | The site has no application server or external runtime dependency, but hosting remains a single-provider dependency. | Managed deployment status and live availability checks are pending deployment. | Confirm provider status, inspect the managed run and source commit, avoid uncontrolled repeated redeployment, and restore from local signed history if repository state is affected. **Owner:** GitHub for platform service; maintainer for project configuration. |
| T-08 | Another site frames the portfolio and misrepresents the context (clickjacking). | Medium / Low / **Low** | No project-controlled prevention exists because meta CSP cannot enforce `frame-ancestors` and Pages does not expose arbitrary response-header configuration. The site has no login, form, session, or state-changing action. | Manual framing tests may document behavior, but absence of protection is already accepted. | Reassess hosting only if interactive features or material harm emerge; otherwise document reports and preserve the accepted-risk decision. **Owner:** maintainer. |
| T-09 | Unnecessary personal information is accidentally published in content, assets, history, or evidence. | Medium / Medium / **Medium** | Public fields are limited to approved name, biography, portrait, professional email, and profile/source links. Original photos, alternate portraits, plans, and private account evidence remain outside the repository. | Manual content review and metadata inspection exist; pre-publication file/history review remains pending. | Remove the information, assess history and third-party copies, contact affected services when appropriate, and revise the publication boundary. **Owner:** maintainer/data subject. |
| T-10 | A maintainer or repository administrator bypasses or weakens repository protections. | Medium / High / **High** | Single-maintainer access limits principals; narrow ruleset design is recorded but pending. Account hardening remains the primary preventive boundary. | Dated ruleset, Actions, deployment, and account reviews are pending Phase 6–9 and quarterly maintenance. | Restore settings, rotate access if misuse is suspected, audit changes and deployments, and recover from a trusted signed state. **Owner:** maintainer; GitHub operates enforcement. |
| T-11 | A trusted outbound link leads to a compromised, changed, or privacy-invasive external service. | Medium / Medium / **Medium** | Only four owner-approved links are exposed; identity links use canonical HTTPS URLs and `noreferrer` where applicable. | Manual destination review is pending the Phase 7 release gate and ongoing content review. | Correct or remove the link through a signed update and notify visitors if a material project-originated risk existed. **Owner:** maintainer for links; external provider for destination security. |

## Accepted residual risks

- **Meta-CSP limitations and framing:** `frame-ancestors`, `sandbox`, CSP reporting, and other header-only controls are unavailable to project HTML. Clickjacking is accepted while the site remains noninteractive.
- **GitHub control-plane dependency:** GitHub administrators and the account owner can affect repository protections; project controls cannot independently prevent GitHub compromise or outage.
- **Public-data persistence:** published content and Git history can be cloned, cached, archived, or indexed after removal.
- **External destinations:** the project cannot guarantee the security, privacy, content, or availability of linked services.
- **Pattern-based verification:** `check.sh` catches the project's expected unsafe changes but is not a parser or formal proof.
- **No independent high-availability layer:** the project accepts a single hosting provider rather than adding operational complexity for a personal portfolio.

## Explicitly out of scope

- compromise or malicious operation of GitHub's infrastructure;
- large-scale distributed denial-of-service attacks against GitHub;
- compromise, malware, or extensions on a visitor's device;
- physical attacks against visitors or the maintainer;
- vulnerabilities wholly within GitHub, LinkedIn, email providers, browsers, or network operators;
- impersonation on unrelated domains or social networks; and
- protection of information the owner intentionally publishes from ordinary viewing and copying.

Out of scope does not mean unimportant. A relevant report is routed to the provider or handled under the incident plan when project action can reduce harm.

## Review

- **Last reviewed:** 2026-11-26
- **Required next review:** before the first public push and again after live verification
- **Routine review after deployment:** quarterly
- **Immediate review triggers:** a new script, page, form, dependency, external resource, custom domain, hosting layer, collaborator, data field, repository owner, deployment method, security incident, GitHub platform behavior change, or proposed relaxation of CSP
