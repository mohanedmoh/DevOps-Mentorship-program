#!/usr/bin/env bash
# Runs the whole exercise without an editor, so you can compare your result.
# Usage: ./solution.sh [folder]  (the folder must not exist yet)
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
dir="${1:-git-solution}"
"$here/practice.sh" "$dir" > /dev/null
cd "$dir/work"

# One: tidy the last seven commits. The editor is replaced by a sed script
# that squashes the wip commits into the commit before them and rewords "oops".
GIT_SEQUENCE_EDITOR="sed -i -e '/ wip$/s/^pick/fixup/' -e '/ wip again$/s/^pick/fixup/' -e '/ oops$/s/^pick/reword/'" \
GIT_EDITOR="sed -i '1s/.*/Reword the notes line/'" \
  git rebase -q -i HEAD~7

# Two: change the last commit instead of adding another one.
echo "Both checks are in the test folder." >> README.md
git add README.md
git commit -q --amend --no-edit

# Three: rebase onto main and resolve the conflict in notes.txt.
git fetch -q origin
if git rebase -q origin/main; then
  echo "No conflict this time."
else
  printf '# Notes\n\nline: hi from the feature\n' > notes.txt
  git add notes.txt
  GIT_EDITOR=true git rebase --continue > /dev/null
fi

# Four: the history changed, so a plain push is refused. Push with a lease.
git push -q --force-with-lease origin feature/greeting

echo "Done. The branch now reads:"
git log --oneline --graph origin/main feature/greeting
