# File Management Lab - mkdir, touch, cp, mv, rm

> Lab 2 from IITC DevOps course. Completed 2026-03-08.
> Score: 100/100

## Lab Overview

Practice creating, copying, moving, renaming, and deleting files and directories using only CLI commands. No GUI, no sudo.

## Commands Learned

| Command | Purpose | Key Behavior |
|---------|---------|-------------|
| `mkdir dir` | Create a single directory | Fails if parent doesn't exist |
| `mkdir -p path/to/dir` | Create nested directories | Creates all missing parents; no error if exists (idempotent) |
| `touch file` | Create empty file / update timestamp | Creates if missing, updates mtime if exists |
| `cp src dest` | Copy file | Creates independent duplicate; original unchanged |
| `cp file1 file2 dir/` | Copy multiple files to directory | Last argument must be a directory |
| `mv src dest` | Move file to new location | File disappears from source (cut+paste) |
| `mv old new` | Rename file (same directory) | Same command, different use case |
| `mv dir1/old.txt dir2/new.txt` | Move + rename in one operation | Relocate and rename simultaneously |
| `rm file` | Delete file permanently | No confirmation, no trash, no undo |
| `rm -r dir` | Delete directory and all contents recursively | Recursive - use with extreme caution |
| `rm -f file` | Force delete - no error if file doesn't exist | `-f` = force (suppresses errors) |
| `rm -rf dir` | Force recursive delete - no prompts, no errors | Most dangerous command in Linux |
| `rmdir dir` | Delete empty directory only | Fails with error if directory has contents |
| `find dir -type f` | Find all files recursively (no directories) | `-type f` = files only |
| `ls -R` | Recursive listing of all subdirectories | Capital R = Recursive |

## Level 1: File Creation and Deletion

### Exercise 1 - Create and Delete Files

Built the base lab structure and practiced file lifecycle:

```bash
mkdir linux_lab
mkdir linux_lab/docs linux_lab/scripts linux_lab/logs
touch linux_lab/docs/notes.txt
rm linux_lab/docs/notes.txt        # Gone instantly. No warning.
touch linux_lab/docs/notes.txt     # Recreated
```

**Key observation:** `rm` deletes immediately with no confirmation. No trash bin in CLI. Unlike GUI delete which moves to recycle bin, CLI delete is permanent and instant.

### Exercise 2 - rmdir vs rm

Attempted to delete a non-empty directory:

```bash
rmdir linux_lab/docs
# rmdir: failed to remove 'linux_lab/docs': Directory not empty
```

**Key observation:** `rmdir` is a safety mechanism - it refuses to delete directories that contain files. To delete a non-empty directory, you must either remove all files first or use `rm -r` (recursive).

### Exercise 3 - Copying Files with cp

Created a file, copied it, then modified the original:

```bash
echo '#!/bin/bash' > linux_lab/scripts/config.sh
echo 'echo Hello' >> linux_lab/scripts/config.sh
cp linux_lab/scripts/config.sh linux_lab/logs/config.sh
echo 'echo World' >> linux_lab/scripts/config.sh
```

Result:
```
=== ORIGINAL ===
#!/bin/bash
echo Hello
echo World

=== COPY ===
#!/bin/bash
echo Hello
```

**Key observation:** `cp` creates a snapshot - an independent copy with no link to the original. Changes to the original after copying do not affect the copy. This is not a symlink or reference.

## Level 2: Moving and Renaming

### Exercise 1 - Move Files (and Fix Mistakes)

Moved a file to the wrong directory, then fixed it:

```bash
mv linux_lab/scripts/run.sh linux_lab/docs/      # Oops - wrong place
ls linux_lab/scripts/                              # run.sh gone from here
ls linux_lab/docs/                                 # run.sh appeared here
mv linux_lab/docs/run.sh linux_lab/scripts/        # Fixed
```

**Key observation:** `mv` is cut+paste, not copy+paste. The file disappears from the source. Fixing a wrong move is just another `mv` in reverse.

### Exercise 2 - Renaming with mv

```bash
touch linux_lab/scripts/my_very_long_script_name.sh
mv linux_lab/scripts/my_very_long_script_name.sh linux_lab/scripts/short.sh
```

**Key observation:** Linux has no separate `rename` command. `mv` handles both moving (different directory) and renaming (same directory). You can even combine both in one command: `mv dir1/old.txt dir2/new.txt`.

### Exercise 3 - Combining cp and mv

Simulated a version control workflow:

```bash
echo "Version 1.0" > linux_lab/scripts/app.sh
cp linux_lab/scripts/app.sh linux_lab/docs/app_backup.sh   # Backup v1
echo "Version 2.0" > linux_lab/scripts/app.sh               # Update to v2
mv linux_lab/docs/app_backup.sh linux_lab/logs/app_v1.sh    # Move + rename backup
```

**When to use cp:** When you need the original to stay (backups, templates, safety copies).
**When to use mv:** When you want to relocate or rename without duplicating (organizing, restructuring).

## Level 3: Directory Structures

### Exercise 1 - mkdir vs mkdir -p

```bash
mkdir linux_lab/projects/app1
# mkdir: cannot create directory 'linux_lab/projects/app1': No such file or directory

mkdir -p linux_lab/projects/app1    # Works - creates 'projects' and 'app1'
```

**Key observation:** `mkdir` fails when parent directory doesn't exist. `mkdir -p` (parents) creates the entire path including all missing directories. Bonus: `-p` won't error if directory already exists, making it safe and idempotent for scripts.

### Exercise 2 - Complex Nested Structures

```bash
mkdir -p linux_lab/projects/app1/src linux_lab/projects/app1/docs linux_lab/projects/app2/tests
mkdir -p linux_lab/deep/nested/directory/structure/here
touch linux_lab/deep/nested/directory/structure/here/file.txt
```

Created 5 directory levels deep in a single command. Used `find linux_lab -type f` to verify all 19 files across the entire tree.

### Exercise 3 - Final Challenge

Combined all commands in a project management scenario:

```bash
mkdir -p linux_lab/project/src linux_lab/project/docs linux_lab/project/tests linux_lab/backups
touch linux_lab/project/src/main.sh linux_lab/project/src/utils.sh linux_lab/project/docs/README.txt
cp linux_lab/project/src/main.sh linux_lab/project/src/utils.sh linux_lab/backups/
mv linux_lab/project/src/utils.sh linux_lab/project/src/utilities.sh
rm linux_lab/backups/utils.sh
```

Final structure verified with `find linux_lab -type f | sort` - 19 files across a clean directory tree.

## Quotes in Bash

| Type | Syntax | Behavior | Use When |
|------|--------|----------|----------|
| Single quotes | `'text'` | Literal — bash does NOT interpret anything | String contains `!`, `$`, or special chars you want preserved |
| Double quotes | `"text"` | Bash interprets `$VAR`, `$()`, etc. | You want variable expansion |

```bash
echo "Hello $USER"   # → Hello david   (interprets $USER)
echo 'Hello $USER'   # → Hello $USER   (literal, no interpretation)
echo "It's done!"    # → error on some shells (! triggers history)
echo 'It'"'"'s done' # → It's done (workaround with single quotes)
```

**Rule of thumb:** When in doubt with special characters, use single quotes.

## Common Mistakes

| Mistake | What Happens | How to Avoid |
|---------|-------------|-------------|
| Using `mv` when task says "copy" | Original file disappears | Re-read the task. `cp` keeps original, `mv` removes it |
| `cp dir/` without `-r` flag | Error: omitting directory | Use `cp -r src dest` for directories |
| Confusing `-r` (recursive) with `-f` (force) | Wrong behavior, possible data loss | `-r` = goes deep, `-f` = no errors. `rm -rf` = both |
| Typo in directory name (`docks` vs `docs`) | Creates wrong dir silently | Always `ls` after creation to verify |
| Wrong path prefix (`linux_lab/` vs `linux_lab2/`) | Operates on wrong location | Double-check prefix before Enter |
| Using double quotes with `!` | bash history expansion error | Use single quotes: `echo 'text!'` |
| `rmdir` on non-empty directory | Error, nothing deleted | Use `rm -r` or clear contents first |
| `rm -rf` with wrong path | Deletes unintended tree | Triple-check path. No undo. |

## Decision Matrix: Which Command When?

| Scenario | Command | Why |
|----------|---------|-----|
| Create single directory | `mkdir` | Simple, fails loud if parent missing (good for catching errors) |
| Create nested path | `mkdir -p` | Creates all parents, idempotent, safe for scripts |
| Create empty file | `touch` | Also useful for updating timestamps |
| Duplicate a file (keep original) | `cp` | Independent snapshot, no link to source |
| Relocate a file | `mv` | Removes from source, appears at destination |
| Rename a file | `mv` | Same command, same directory |
| Delete a file permanently | `rm` | Instant, no confirmation, no undo |
| Delete empty directory | `rmdir` | Safe - refuses if not empty |
| Delete directory with contents | `rm -r` | Recursive nuclear option - think twice |

## Operator Reference

| Operator | Meaning | Example |
|----------|---------|---------|
| `>` | Write to file (overwrite) | `echo "v2" > app.sh` |
| `>>` | Append to file (add to end) | `echo "new line" >> log.txt` |
| `\|` | Pipe output to next command | `find . -type f \| sort` |
| `&&` | Run next only if previous succeeded | `mkdir dir && cd dir` |
| `2>/dev/null` | Suppress error messages | `ls missing_file 2>/dev/null` |

## Iron Rules Earned

- **"`rm` is a one-way ticket"** - no undo, no trash, no confirmation. Think before you type.
- **"`mkdir -p` is your friend in scripts"** - idempotent directory creation, safe to run repeatedly.
- **"`>` overwrites, `>>` appends"** - confuse these once and you lose data. Know the difference.
- **"`mv` does double duty"** - move and rename are the same operation in Linux.
- **"`cp` creates a snapshot, not a link"** - after copying, original and copy are independent forever.
- **"`rmdir` is the safety net"** - it refuses to delete non-empty directories, unlike `rm -r`.
- **"Always verify with `ls` or `find`"** - check before and after destructive operations.
