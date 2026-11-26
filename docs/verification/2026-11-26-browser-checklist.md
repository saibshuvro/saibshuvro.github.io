# Live browser checklist — 2026-11-26

## Scope

- Target: `https://saibshuvro.github.io/`
- Unique 404 path: `/phase9-verification-missing-2026-11-26`
- Deployed commit: `ccd64191fb4934960373375026b9564d6f748238`
- Observation time: `2026-11-26T14:54:09Z` / `2026-11-26T20:54:09+06:00`
- Operator: maintainer-assisted Codex verification
- Browsers: Google Chrome `158.0.8127.36`; official Mozilla Firefox `161.0`

The Firefox archive was obtained from Mozilla's release host and its SHA-512 digest
matched Mozilla's published `SHA512SUMS` entry before execution. Temporary browser
profiles, automation code, and screenshots were kept outside committed evidence.

## Homepage results

| Check | Expected | Observed | Result |
| --- | --- | --- | --- |
| HTTPS document | Homepage succeeds at the canonical URL | Chrome observed document `200`; curl HEAD and GET also returned `200` | Pass |
| Identity content | Approved name, biography, and tagline | Exact approved name, complete biography, and `Building backend systems with security in mind.` were present | Pass |
| Runtime assets | CSS and portrait load from the site origin | `/styles/main.css` and `/assets/portrait.jpg` returned `200`; portrait decoded at `1254` by `1254` | Pass |
| Approved links | GitHub, LinkedIn, Email, and Source use their approved destinations | Four labels and exact destinations matched the checked-in page | Pass |
| Responsive layout | Desktop, mobile, and 320 px remain readable without horizontal overflow | Chrome passed at `1440x1000`, `375x812`, and `320x900`; Firefox visually passed at the same sizes | Pass |
| Keyboard focus | Every interactive element has visible focus | Chrome tab order was GitHub, LinkedIn, Email, Source; every link showed a solid `2px` focus outline | Pass |
| Console | No unexpected warning, exception, CSP error, or resource failure | Homepage console/security capture contained no problem entry | Pass |
| Network | No unexpected or third-party runtime request | Only the document, same-origin CSS, and same-origin portrait were requested; no failed request | Pass |
| Mixed content | No HTTP subresource or mixed-content warning | No insecure request or mixed-content browser entry appeared | Pass |
| Client state | No project cookie or browser storage | Empty cookie string and zero local/session-storage entries | Pass |

At 320 px, Firefox wrapped the Source link onto a second line; the flex layout
remained centered, readable, and free of clipping or horizontal overflow.

## Custom 404 results

The unique path returned HTTP `404`, rendered the custom `Page not found` document,
loaded `/styles/main.css` with `200`, and exposed a working same-origin Return home
link with the same visible focus treatment. Chrome's one console error was the
expected browser message for the top-level document's intentional `404` response;
there was no failed CSS or other unexpected resource.

The served body matched repository `404.html` byte-for-byte. Chrome and Firefox
both rendered the error layout correctly at `375x812`.

## CSP and privacy observations

Chrome read the following normalized policy from the live document:

```text
default-src 'none'; base-uri 'none'; form-action 'none'; script-src 'none'; style-src 'self'; img-src 'self'; object-src 'none'; connect-src 'none'; upgrade-insecure-requests
```

The homepage and 404 required no policy exception. They contained no script, inline
style, form, frame, object, embed, audio, video, or base element. The Phase 7 local
negative tests remain the enforcement evidence for prohibited script, style, image,
base, and connection attempts; no hostile probe was added to the public site.

Because the policy is meta-delivered, it cannot enforce `frame-ancestors`, `sandbox`,
or reporting directives. Framing remains an accepted low-impact residual risk while
the site has no authentication, form, session, or state-changing action.

## Outbound-link observations

- GitHub profile: exact approved HTTPS URL; automated HEAD result `200`.
- Source repository: exact approved HTTPS URL; automated HEAD result `200`.
- LinkedIn: exact approved HTTPS URL. LinkedIn returned `999` to the automated HEAD
  request, so that anti-automation response is not represented as destination
  availability evidence.
- Email: exact approved `mailto:` destination; no network request occurs until a
  visitor chooses to open a configured mail client.

## Evidence boundary and conclusion

Expected and observed behavior matched. No screenshot is committed: captures were
temporary, contained only public site content, and were used for visual review.
Raw public-API signatures, transient request identifiers, browser profiles, cookies,
tokens, session data, account menus, and unrelated browsing content were excluded.

Conclusion: **Pass** for the tested deployed commit, browsers, viewports, and time.
This is a dated observation rather than a guarantee of future platform or linked-site
behavior.
