# Security verification

The repository includes a dependency-free static verifier for the constraints that keep the published site small and auditable.

## Run the static checks

From any working directory, run:

```sh
/path/to/saibshuvro.github.io/scripts/check.sh
```

From the repository root, the shorter equivalent is:

```sh
./scripts/check.sh
```

The command exits with status `0` only when all checks pass. It reports every detected issue and exits nonzero otherwise. It reads project files but does not modify them.

## Coverage

The verifier checks:

- required project files and every HTML document in the publication tree;
- the exact frozen meta Content Security Policy on every HTML page;
- `no-referrer`, document-language, and viewport metadata;
- absence of scripts, inline event handlers, `javascript:` URLs, inline CSS, forms, embedded media, frames, plug-in content, and base elements;
- absence of insecure HTTP references, remote resource dependencies, CSS imports, external CSS URLs, and JavaScript files;
- existence of root-relative resources referenced by HTML;
- the four approved homepage navigation labels; and
- alternative text and explicit dimensions on the portrait.

Outbound HTTPS links in anchor elements are permitted. The remote-resource checks target resource-loading attributes and `<link>` elements, so links to GitHub and LinkedIn are not mistaken for dependencies.

## Limitations

These pattern-based checks are defense in depth. They are intentionally readable, but they are not a full HTML or CSS parser and do not prove that the site is secure. An unusual but syntactically valid representation may require the verifier to be updated.

The script cannot confirm browser enforcement, response headers, TLS behavior, GitHub Pages configuration, DNS, live availability, or the content returned by the deployed origin. Those properties require separate browser tests and live-deployment checks. Account security, branch protection, commit-signature status, and repository settings must also be verified through GitHub rather than from the publication files.

Do not put credentials, tokens, private keys, or raw secret-scanner findings in verification logs or committed evidence.

## Verifier self-test record

On 2026-11-25, the valid site passed under both `sh` and `dash`, including an invocation from outside the repository. Disposable copies were then changed one at a time to introduce a script element, an inline event handler, inline CSS, a remote image, an insecure HTTP link, missing root-relative and relative local stylesheets, a missing CSP, a missing referrer policy, a CSS import without intervening whitespace, and a multiline remote stylesheet. All eleven fixtures exited nonzero and identified the expected violation. The disposable copies were removed after the test.
