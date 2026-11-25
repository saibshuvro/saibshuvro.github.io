#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -P -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -P -- "$SCRIPT_DIR/.." && pwd)
FAILURES=0

HTML_LIST=$(mktemp)
CSS_LIST=$(mktemp)
ATTRIBUTES=$(mktemp)

cleanup() {
  rm -f -- "$HTML_LIST" "$CSS_LIST" "$ATTRIBUTES"
}

trap cleanup EXIT HUP INT TERM

pass() {
  printf 'PASS  %s\n' "$1"
}

fail() {
  printf 'FAIL  %s\n' "$1" >&2
  FAILURES=$((FAILURES + 1))
}

relative_name() {
  printf '%s\n' "${1#"$REPO_ROOT"/}"
}

html_check_absent() {
  pattern=$1
  message=$2
  found=0

  while IFS= read -r html_file; do
    if grep -Eiq -- "$pattern" "$html_file"; then
      fail "$message: $(relative_name "$html_file")"
      found=1
    fi
  done < "$HTML_LIST"

  if [ "$found" -eq 0 ]; then
    pass "$message"
  fi
}

find "$REPO_ROOT" -path "$REPO_ROOT/.git" -prune -o -type f -name '*.html' -print > "$HTML_LIST"
find "$REPO_ROOT" -path "$REPO_ROOT/.git" -prune -o -type f -name '*.css' -print > "$CSS_LIST"

required_files='index.html
404.html
.gitignore
.nojekyll
assets/portrait.jpg
styles/main.css
scripts/check.sh'

missing_required=0
while IFS= read -r relative_path; do
  if [ ! -f "$REPO_ROOT/$relative_path" ]; then
    fail "required file is missing: $relative_path"
    missing_required=1
  fi
done <<EOF
$required_files
EOF

if [ "$missing_required" -eq 0 ]; then
  pass 'required project files exist'
fi

if [ ! -s "$HTML_LIST" ]; then
  fail 'no HTML files were found'
fi

expected_csp="default-src 'none'; base-uri 'none'; form-action 'none'; script-src 'none'; style-src 'self'; img-src 'self'; object-src 'none'; connect-src 'none'; upgrade-insecure-requests"
csp_failed=0
metadata_failed=0

while IFS= read -r html_file; do
  file_name=$(relative_name "$html_file")
  flattened_html=$(tr '\n' ' ' < "$html_file" | tr -s '[:space:]' ' ' | tr '[:upper:]' '[:lower:]')
  actual_csp=$(printf '%s\n' "$flattened_html" | sed -n 's/.*<meta[[:space:]][^>]*http-equiv="content-security-policy"[^>]*content="[[:space:]]*\([^"]*\)[[:space:]]*"[^>]*>.*/\1/p')
  actual_csp=$(printf '%s\n' "$actual_csp" | tr -s '[:space:]' ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

  if [ -z "$actual_csp" ]; then
    fail "CSP meta policy is missing or malformed: $file_name"
    csp_failed=1
  elif [ "$actual_csp" != "$expected_csp" ]; then
    fail "CSP does not match the frozen policy: $file_name"
    csp_failed=1
  fi

  if ! printf '%s\n' "$flattened_html" | grep -Eq -- '<meta[[:space:]][^>]*name="referrer"[^>]*content="no-referrer"[^>]*>'; then
    fail "no-referrer policy is missing: $file_name"
    metadata_failed=1
  fi

  if ! printf '%s\n' "$flattened_html" | grep -Eq -- '<html[[:space:]][^>]*lang="[^"]+"'; then
    fail "document language is missing: $file_name"
    metadata_failed=1
  fi

  if ! printf '%s\n' "$flattened_html" | grep -Eq -- '<meta[[:space:]][^>]*name="viewport"[^>]*content="width=device-width,[[:space:]]*initial-scale=1"[^>]*>'; then
    fail "responsive viewport is missing: $file_name"
    metadata_failed=1
  fi
done < "$HTML_LIST"

if [ "$csp_failed" -eq 0 ]; then
  pass 'every HTML page contains the frozen CSP'
fi

if [ "$metadata_failed" -eq 0 ]; then
  pass 'every HTML page declares no-referrer, language, and viewport metadata'
fi

html_check_absent '<script([[:space:]>])' 'no script elements exist'
html_check_absent '[[:space:]]on[a-z][a-z0-9_-]*[[:space:]]*=' 'no inline event handlers exist'
html_check_absent 'javascript[[:space:]]*:' 'no javascript URLs exist'
html_check_absent '<style([[:space:]>])|[[:space:]]style[[:space:]]*=' 'no inline CSS exists'
html_check_absent '<(form|iframe|object|embed|audio|video)([[:space:]>])' 'no prohibited interactive or embedded elements exist'
html_check_absent '<base([[:space:]>])' 'no base elements exist'

http_failed=0
while IFS= read -r source_file; do
  if grep -Fiq -- 'http://' "$source_file"; then
    fail "insecure HTTP reference found: $(relative_name "$source_file")"
    http_failed=1
  fi
done < "$HTML_LIST"
while IFS= read -r source_file; do
  if grep -Fiq -- 'http://' "$source_file"; then
    fail "insecure HTTP reference found: $(relative_name "$source_file")"
    http_failed=1
  fi
done < "$CSS_LIST"

if [ "$http_failed" -eq 0 ]; then
  pass 'no insecure HTTP references exist'
fi

remote_attribute="(src|srcset|poster|data)[[:space:]]*=[[:space:]]*['\"](https?:)?//"
remote_link="<link[^>]*href[[:space:]]*=[[:space:]]*['\"](https?:)?//"
remote_failed=0
while IFS= read -r html_file; do
  if tr '\n' ' ' < "$html_file" | grep -Eiq -- "$remote_attribute|$remote_link"; then
    fail "remote resource dependency found: $(relative_name "$html_file")"
    remote_failed=1
  fi
done < "$HTML_LIST"

if [ "$remote_failed" -eq 0 ]; then
  pass 'HTML resource dependencies are local'
fi

css_failed=0
while IFS= read -r css_file; do
  if grep -Fiq -- '@import' "$css_file"; then
    fail "CSS import found: $(relative_name "$css_file")"
    css_failed=1
  fi

  if grep -Eiq -- "url[[:space:]]*\([[:space:]]*['\"]?(https?:)?//" "$css_file"; then
    fail "external or protocol-relative CSS URL found: $(relative_name "$css_file")"
    css_failed=1
  fi
done < "$CSS_LIST"

if [ "$css_failed" -eq 0 ]; then
  pass 'CSS contains no imports or external URLs'
fi

javascript_file=$(find "$REPO_ROOT" -path "$REPO_ROOT/.git" -prune -o -type f -name '*.js' -print -quit)
if [ -n "$javascript_file" ]; then
  fail "JavaScript file exists in the publication tree: $(relative_name "$javascript_file")"
else
  pass 'no JavaScript files exist in the publication tree'
fi

asset_failed=0
while IFS= read -r html_file; do
  : > "$ATTRIBUTES"
  tr '\n' ' ' < "$html_file" | grep -Eio -- "(src|href|poster|data)[[:space:]]*=[[:space:]]*['\"][^'\"]+\.(css|jpe?g|png|webp|gif|svg|ico|avif)([?#][^'\"]*)?['\"]" > "$ATTRIBUTES" || :

  while IFS= read -r attribute; do
    resource_path=$(printf '%s\n' "$attribute" | sed -e "s/^[^=]*=[[:space:]]*['\"]//" -e "s/['\"]$//" -e 's/[?#].*$//')

    case "$resource_path" in
      http://*|https://*|//*|data:*)
        continue
        ;;
      ../*|*/../*|*/..)
        fail "local resource path escapes the publication tree: $resource_path"
        asset_failed=1
        continue
        ;;
      /*)
        resource_file=$REPO_ROOT$resource_path
        ;;
      *)
        resource_file=$(dirname -- "$html_file")/$resource_path
        ;;
    esac

    if [ ! -f "$resource_file" ]; then
      fail "referenced local resource is missing: $resource_path"
      asset_failed=1
    fi
  done < "$ATTRIBUTES"
done < "$HTML_LIST"

if [ "$asset_failed" -eq 0 ]; then
  pass 'all referenced local resources exist'
fi

labels_failed=0
for label in GitHub LinkedIn Email Source; do
  label_count=$(grep -Eio -- ">[[:space:]]*$label[[:space:]]*<" "$REPO_ROOT/index.html" | wc -l | tr -d ' ')
  if [ "$label_count" -ne 1 ]; then
    fail "homepage link label must appear exactly once: $label"
    labels_failed=1
  fi
done

if [ "$labels_failed" -eq 0 ]; then
  pass 'homepage contains exactly the four approved link labels'
fi

index_flat=$(tr '\n' ' ' < "$REPO_ROOT/index.html" | tr -s '[:space:]' ' ')
portrait_tag=$(printf '%s\n' "$index_flat" | sed -n 's/.*\(<img[^>]*src="\/assets\/portrait.jpg"[^>]*>\).*/\1/p')
if [ -n "$portrait_tag" ] \
  && printf '%s\n' "$portrait_tag" | grep -Eiq -- 'alt="[^"]+"' \
  && printf '%s\n' "$portrait_tag" | grep -Eiq -- 'width="[0-9]+"' \
  && printf '%s\n' "$portrait_tag" | grep -Eiq -- 'height="[0-9]+"'; then
  pass 'portrait has nonempty alt text and explicit dimensions'
else
  fail 'portrait must have nonempty alt text and explicit dimensions'
fi

if [ -f "$REPO_ROOT/.nojekyll" ]; then
  pass '.nojekyll exists'
fi

if [ "$FAILURES" -eq 0 ]; then
  printf '\nAll static security checks passed.\n'
  exit 0
fi

printf '\nStatic security checks failed: %s issue(s).\n' "$FAILURES" >&2
exit 1
