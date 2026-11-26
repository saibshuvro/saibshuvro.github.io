# Responsive viewport review — 2026-11-26

## Scope and goal

This change-triggered review covers a CSS-only refinement intended to keep the full
profile within the initial viewport on common desktop, laptop, and mobile-portrait
sizes without sacrificing readability. Natural vertical scrolling remains available
on short screens, landscape phones, zoomed layouts, and enlarged user text.

- Repository base before the change: `6af8348e135e1d5f40e793f30e61e60ec0eb84fe`
- Candidate files: `styles/main.css`, this review, and documentation references
- Local target: the repository root served over loopback HTTP
- Date and timezone: `2026-11-26`, Asia/Dhaka
- Browsers: Google Chrome `158.0.8127.36`; official Mozilla Firefox `161.0`

The Firefox archive's SHA-512 digest matched Mozilla's published `SHA512SUMS` entry,
and its XZ archive passed integrity validation before execution.

## Implementation

The refinement:

- reduced the portrait's fluid maximum while retaining its square crop;
- capped the desktop heading at `3.75rem`;
- kept introduction text between `17px` and `19px` on wider layouts and at `16px`
  on mobile;
- reduced vertical margins and padding with `clamp()` and `svh` units;
- added a `max-height: 44rem` compact mode for short viewports; and
- retained normal document flow, wrapping, focus styles, and natural scrolling.

It did not add JavaScript, a dependency, a fixed page height, page-level
`overflow: hidden`, `transform: scale()`, hidden content, or a new external resource.
The portrait's existing `overflow: hidden` remains limited to image cropping.

## Chrome measurements

| Viewport | Expected initial behavior | Observed document size | Result |
| --- | --- | --- | --- |
| `1440x900` desktop | Full profile, no scroll | `1440x900`; no horizontal or vertical overflow | Pass |
| `1366x657` laptop content area | Full profile, no scroll | `1366x657`; no horizontal or vertical overflow | Pass |
| `1024x600` compact laptop | Full profile, no scroll | `1024x600`; no horizontal or vertical overflow | Pass |
| `390x844` mobile portrait | Full profile, no scroll | `390x844`; no horizontal or vertical overflow | Pass |
| `375x667` compact mobile portrait | Full profile, no scroll | `375x667`; no horizontal or vertical overflow | Pass |
| `360x640` mobile portrait | Full profile, no scroll | `360x640`; no horizontal or vertical overflow | Pass |
| `320x568` short mobile | Vertical scroll allowed | `320x578`; ten pixels of vertical overflow, no horizontal overflow | Pass |
| `812x375` mobile landscape | Vertical scroll allowed | `797x446`; vertical overflow, no horizontal overflow | Pass |
| `720x450` 200%-zoom equivalent | Scrolling allowed; no horizontal clipping | Full profile happened to fit; no horizontal overflow | Pass |
| `375x667` custom 404 | Full error page, no scroll | `375x667`; no horizontal or vertical overflow | Pass |

At the two intentionally scrollable sizes, the profile began at the document top;
content was not centered above the reachable scroll area or clipped. Chrome reported
no third-party request, failed resource, console warning/error, or mixed-content
request. The only homepage requests were the document, same-origin stylesheet, and
same-origin portrait; source review confirmed that no cookie or browser-storage code
was introduced.

Keyboard order remained GitHub, LinkedIn, Email, Source. Every link, plus the 404
Return home link, retained the solid `2px` focus outline.

## Firefox visual review

Firefox rendered the expected initial layouts at:

- `1366x657` laptop: full profile visible without a scrollbar;
- `375x667` mobile portrait: full profile and all links visible;
- `320x568` short mobile: readable content with natural vertical continuation;
- `812x375` landscape: readable content with natural vertical continuation; and
- `375x667` custom 404: full error page visible.

No horizontal clipping, overlap, hidden text, or unexpected visual regression was
observed. Font metrics differed slightly from Chrome as expected, while hierarchy,
centering, whitespace, and readability remained consistent.

## Verification and limitations

`scripts/check.sh` passed after the CSS change. The publication still contains no
application JavaScript, remote runtime asset, form, analytics, or new data field.

“No initial scroll” is a responsive target, not a universal promise. Browser chrome,
safe areas, user font settings, translations, zoom, assistive technology, and unusual
viewport dimensions can reduce available space. In those conditions, normal vertical
scrolling is the intentional accessible fallback; content is never clipped merely to
hide a scrollbar.

Temporary browser profiles, archives, automation code, scanner output, and screenshots
are excluded from the repository and removed after review.

Conclusion: **Pass locally.** Release acceptance requires the signed change to deploy
successfully and the live origin to retain the tested layout, asset, console, network,
focus, and scrolling behavior.
