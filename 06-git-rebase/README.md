# 06 Git rebase

Task 4.

Four commands that every team uses and many people avoid.

## Set up a practice repository

```bash
./practice.sh my-practice
cd my-practice/work
```

The script makes a bare repository to play the part of GitHub, and a clone with a branch called `feature/greeting`. The branch has seven commits. Some are messy on purpose. Meanwhile `main` has moved on and changed a line your branch also changed.

## One: tidy the last seven commits

```bash
git rebase -i HEAD~7
```

Git opens a list of commits. Change the word at the start of a line to change what happens to that commit:

- `pick` keeps the commit.
- `reword` keeps it and lets you change the message.
- `edit` stops so you can change the files or the commit.
- `squash` melds it into the commit above and lets you combine the messages.
- `fixup` does the same and throws away its message.
- `drop` removes it.

Try this: fix up the two `wip` commits, and reword `oops` into a message that says what it does.

## Two: amend

```bash
git commit --amend
```

Change the last commit, in content or message, instead of adding another. Add a line to `README.md`, stage it and amend.

## Three: rebase onto main

```bash
git fetch origin
git rebase origin/main
```

Your commits are replayed on top of the new `main`. The `notes.txt` line was changed on both sides, so Git stops. Edit the file to what you want, then:

```bash
git add notes.txt
git rebase --continue
```

If it goes wrong, `git rebase --abort` puts everything back.

## Four: push the rewritten branch

You changed history, so a normal push is refused. Do not reach for `--force`.

```bash
git push --force-with-lease origin feature/greeting
```

`--force-with-lease` only overwrites the remote branch if it is still where you last saw it. If a colleague pushed in the meantime, the push fails and their work is safe. Plain `--force` skips that check.

## Check your work

`./solution.sh my-solution` runs the whole exercise with no editor. Compare its `git log` with yours.

## Rules of thumb

- Rewrite only commits you have not shared, or a branch that is yours alone.
- Never rewrite `main`.
- Commit often while you work. Tidy before you open the pull request.
