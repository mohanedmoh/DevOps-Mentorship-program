#!/usr/bin/env bash
# Looks through a folder of Terraform for patterns that have aged badly.
# Usage: ./scan.sh [folder]
# It prints each finding with the file, the line and a short reason.
# The exit status is 1 when anything is found, so it can run in CI.
set -uo pipefail

root="${1:-.}"
found=0
files=()

# Skip git and Terraform internals, this script, and the tfvars templates. The
# teaching fixtures in 07-audit are skipped too, unless you point the scan at them.
skip=(-not -path '*/.git/*' -not -path '*/.terraform/*' -not -name scan.sh -not -name '*.tfvars.example')
case "$root" in
  *07-audit*) ;;
  *) skip+=(-not -path '*/07-audit/*') ;;
esac

while IFS= read -r -d '' f; do
  files+=("$f")
done < <(find "$root" -type f \( -name '*.tf' -o -name '*.tfvars' -o -name '*.tftpl' -o -name '*.sh' -o -name '*.example' \) \
  "${skip[@]}" -print0)

if [ "${#files[@]}" -eq 0 ]; then
  echo "No Terraform files found in $root"
  exit 0
fi

finding() {
  printf '%s:%s\n    %s\n' "$1" "$2" "$3"
  found=$((found + 1))
}

check() {
  local pattern="$1" message="$2" out line file number
  out=$(grep -nHE "$pattern" "${files[@]}" 2>/dev/null) || return 0
  while IFS= read -r line; do
    file="${line%%:*}"
    number=$(printf '%s' "$line" | cut -d: -f2)
    finding "$file" "$number" "$message"
  done <<< "$out"
}

check '^[[:space:]]*vpc[[:space:]]*=[[:space:]]*true' \
  'aws_eip: use domain = "vpc". The vpc argument is no longer documented.'
check 'dynamodb_table' \
  'S3 backend: DynamoDB locking is deprecated. Use use_lockfile = true.'
check 'amzn2|amazon linux 2([^0-9]|$)' \
  'Amazon Linux 2 reached end of support on 30 June 2026. Use Amazon Linux 2023.'
check 'ubuntu-focal|20\.04' \
  'Ubuntu 20.04 standard support ended in May 2025. Use a current LTS release.'
check 'engine_version[[:space:]]*=[[:space:]]*"5\.7' \
  'RDS for MySQL 5.7 is in Extended Support, which costs extra and ends on 30 June 2029. Use 8.4.'
check 'engine_version[[:space:]]*=[[:space:]]*"8\.0' \
  'RDS for MySQL 8.0 left standard support on 31 July 2026 and is now in paid Extended Support. Use 8.4.'
check '"t1\.micro"' \
  't1.micro is a previous generation type. Use a current type such as t3.micro.'
check 'AmazonEC2RoleforSSM' \
  'AmazonEC2RoleforSSM is being deprecated. Use AmazonSSMManagedInstanceCore.'
check '"[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/32"' \
  'A fixed address in code. Take it from a variable so it is not committed.'
check '(password|secret|token)[[:space:]]*=[[:space:]]*"[^"$]{4,}"' \
  'Looks like a credential in code. Keep secrets out of the code and the state file.'

# Registry modules need a version constraint, or the next major release arrives unannounced.
for f in "${files[@]}"; do
  case "$f" in *.tf | *.example) ;; *) continue ;; esac
  while IFS= read -r hit; do
    [ -n "$hit" ] || continue
    finding "$f" "${hit%%|*}" "${hit#*|}"
  done < <(awk '
    function count(s, ch,   t) { t = s; return gsub(ch, "", t) }
    /^[ \t]*module[ \t]+"/ && !inmod { inmod = 1; start = NR; name = $2; src = ""; ver = 0; depth = 0 }
    inmod {
      if ($0 ~ /^[ \t]*source[ \t]*=/) src = $0
      if ($0 ~ /^[ \t]*version[ \t]*=/) ver = 1
      depth += count($0, "{") - count($0, "}")
      if (depth <= 0) {
        local = (src ~ /"\.\.?\//)
        vcs = (src ~ /(git::|github\.com|bitbucket|s3::|https?:|gcs::|hg::)/)
        if (!local && !vcs && src != "" && !ver) {
          gsub(/"/, "", name)
          printf "%d|module %s uses a registry source with no version constraint.\n", start, name
        }
        inmod = 0
      }
    }
  ' "$f")
done

# State files should never be committed.
if git -C "$root" rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  while IFS= read -r tracked; do
    [ -n "$tracked" ] || continue
    finding "$tracked" "1" "A Terraform state file is tracked by git. It can hold secrets. Remove it and add it to .gitignore."
  done < <(git -C "$root" ls-files | grep -E '\.tfstate(\.|$)')
fi

echo
if [ "$found" -eq 0 ]; then
  echo "No findings."
  exit 0
fi
echo "$found findings."
exit 1
