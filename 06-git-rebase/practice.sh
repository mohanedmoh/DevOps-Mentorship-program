#!/usr/bin/env bash
# Builds a practice repository for the Git exercises.
# Nothing here touches your real projects. Usage: ./practice.sh [folder]
set -euo pipefail

dir="${1:-git-practice}"
if [ -e "$dir" ]; then
  echo "$dir already exists. Pick another name or remove it first." >&2
  exit 1
fi

mkdir -p "$dir"
cd "$dir"

# A bare repository plays the part of GitHub.
git init -q --bare remote.git
git clone -q remote.git work 2>/dev/null
cd work
git config user.name "Practice User"
git config user.email "practice@example.com"
git checkout -q -b main

commit() {
  git add -A
  git commit -q -m "$1"
}

printf '# Notes\n\nline: hello\n' > notes.txt
commit "Add notes file"
git push -q -u origin main

# A feature branch with seven commits, some of them messy on purpose.
git checkout -q -b feature/greeting

echo "hello world" > greeting.txt
commit "Add greeting"

echo "wip" >> greeting.txt
commit "wip"

echo "hello, world" > greeting.txt
commit "Fix typo"

echo "goodbye" > farewell.txt
commit "Add farewell"

echo "goodbye, world" > farewell.txt
commit "wip again"

sed -i 's/^line: hello$/line: hello from the feature/' notes.txt
commit "oops"

echo "Run the greeting and farewell checks before you merge." > README.md
commit "Update docs"

git push -q -u origin feature/greeting

# Meanwhile main moves on and changes the same line in notes.txt.
git checkout -q main
sed -i 's/^line: hello$/line: hi/' notes.txt
commit "Change notes wording"
git push -q origin main

git checkout -q feature/greeting

echo
echo "Practice repository ready in: $(pwd)"
echo "You are on feature/greeting, seven commits ahead of where main used to be."
git log --oneline --graph --all
