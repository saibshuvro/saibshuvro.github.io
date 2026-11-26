# Pre-publication review — 2026-11-26

## Status and scope

This record was prepared over the signed base at commit `5ceaf27` plus the reviewed release changes for inclusion in the next signed commit, before creation of the public repository. It records sanitized outcomes rather than raw scanner reports, browser profiles, screenshots, account data, or disposable probe content. Because a commit cannot contain the result of scanning its own final object, the resulting signed commit receives one more clean-archive check and full-history scan immediately before the first push.

## Source and history review

- The committed tree contains only the approved 15 files: two HTML pages, one CSS file, one portrait, the static verifier, repository boundary files, and public engineering/security documentation.
- Every path introduced across all five commits was inspected through Git history.
- No JavaScript, package manifest, lockfile, environment file, archive, editor workspace, temporary file, or `.github/workflows/` path is committed.
- The generated visual reference, original portrait, and alternate portrait candidates remain outside the repository.
- Published personal data is limited to the owner-approved name, biography, tagline, portrait, professional email, GitHub profile, LinkedIn profile, intended source URL, and the sanitized public-profile decision record.
- All five commits have valid local SSH signatures from the dedicated portfolio signing key.
- No Git remote was configured during the local gate.

## Static verification

`./scripts/check.sh` passed in the working repository and in a disposable copy containing the complete release candidate but no `.git` directory. The verifier resolved its root and passed every check in that copy. The signed base had also passed from a clean `git archive HEAD`; the release procedure repeats that archive check against the exact signed commit immediately before the first push.

Three disposable negative fixtures removed the tagline, duplicated it, or placed the exact text in the wrong HTML element. Each exited nonzero with the expected tagline-rule failure. The fixtures remained outside the repository and were removed.

Local Markdown documentation links were also checked against the real tree. No missing local target was found.

## Secret scanning

- Tool: Gitleaks `8.30.1`
- Distribution: official Linux x64 release archive, executed from a temporary directory
- Archive SHA-256: `551f6fc83ea457d62a0d98237cbad105af8d557003051f41f3e7ca7b3f2470eb`
- Scope: all reachable Git refs using `--log-opts='--all'`
- Redaction: `--redact=100`, with no-color and no-banner output
- Result: five commits scanned, zero findings

No allowlist, baseline, `.gitleaksignore`, custom exclusion, or finding dismissal was used. Gitleaks and GitHub secret scanning are pattern-based controls and do not detect every possible secret format.

After the tagline and evidence updates, a separate scan of the complete working tree also returned zero findings. The release procedure covers the resulting signed commit with one more full-history scan before the first public push.

## Portrait and content review

- `assets/portrait.jpg` is a progressive 8-bit JPEG with three color components.
- Dimensions: `1254×1254`
- Size: `176071` bytes
- JPEG segments before image data contain quantization, progressive-frame, Huffman, and scan tables only.
- No EXIF, XMP, ICC profile, IPTC/Photoshop, GPS, software/device, date-original, or JPEG comment marker was found.
- The committed portrait is byte-distinct from the generated visual reference, original owner photograph, and local portrait candidate.
- Visual inspection confirmed the approved square monochrome portrait with no unintended identifying text or background detail.
- The alternative text is `Portrait of Saib Saleh Nabil`, with matching explicit width and height attributes.

The four homepage links were checked against their approved values:

- GitHub profile: canonical HTTPS URL returned success.
- LinkedIn profile: canonical owner-approved HTTPS URL retained; LinkedIn rejected the command-line availability probe with its anti-automation status.
- Email: approved monitored professional `mailto:` address, reconfirmed during the account review.
- Source: points to the exact intended public repository and correctly remained unavailable before repository creation.

## Browser matrix

### Browsers

- Google Chrome `158.0.8127.36`
- Mozilla Firefox `161.0` from an official temporary Linux build

### Clean-site results

- The owner-approved tagline was added after the first matrix, so every affected layout, responsive, keyboard, zoom, failure-state, console, network, and CSP check was repeated against the changed candidate.
- The exact tagline appeared once in its own paragraph between the biography and divider.
- Computed font sizes kept it subordinate to the biography: `18px` versus `24px` at desktop and `15px` versus `17px` at the tested narrow viewports.
- Its muted color retained a measured `6.69:1` contrast ratio against the white background.
- Desktop and mobile-sized homepage layouts rendered correctly in both browser engines.
- The `375px` and `320px` views wrapped the tagline cleanly without horizontal overflow.
- Chrome's 200% reflow simulation used half the CSS viewport width with a device scale factor of two; content reflowed without horizontal overflow.
- The four focusable links appeared in the intended GitHub, LinkedIn, Email, Source order with a visible two-pixel focus outline.
- The custom `404.html` rendered correctly in both engines and its return-home link remained visible.
- Blocking the portrait preserved all text, navigation, layout structure, and meaningful alternative text.
- Blocking CSS left the semantic content and links available, with expected unstyled-image overflow.
- Normal Chrome loads produced no console error, CSP violation, failed resource, or third-party request.
- Observed clean-page requests were limited to the loopback HTML page, same-origin stylesheet, and same-origin portrait/icon.

### Disposable CSP negative tests

A disposable copy outside the repository introduced one inline script, one same-origin external script, one inline `<style>` block, one `style` attribute, and a same-origin API request initiated through browser developer tooling.

Chrome observed and logged all five expected violations:

- `script-src 'none'` blocked inline script execution;
- `script-src 'none'` blocked the external script;
- `style-src 'self'` blocked the `<style>` block;
- `style-src 'self'` blocked the `style` attribute; and
- `connect-src 'none'` blocked the API request.

Neither script marker appeared in the document, the red style values were not applied, and the API promise rejected. The probes never entered the repository or Git history.

## Pending external controls

The following are intentionally not claimed complete in this record:

- creation and first push of the public repository;
- GitHub `Verified` status for every commit;
- repository secret-scanning and push-protection review;
- restricted Actions permissions;
- the active narrow `main` ruleset and its signed-update test; and
- GitHub Pages deployment, HTTPS, live headers, and live browser/404 verification.

Pages deployment remains Phase 8. Live-site evidence remains Phase 9.
