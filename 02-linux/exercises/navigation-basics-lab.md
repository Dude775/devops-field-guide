# Navigation Basics Lab (Lab 1)

> Lab 1 from IITC DevOps course. Topic: cd, ls, pwd, hidden files, error messages, directory navigation.

## Commands Learned

### Navigation Commands

| Command | Syntax | What It Does |
|---------|--------|-------------|
| `pwd` | `pwd` | Print Working Directory — shows your current full path |
| `cd` | `cd <path>` | Change Directory — move to a different location |
| `cd ~` | `cd ~` | Go to home directory (shortcut) |
| `cd ..` | `cd ..` | Go up one level (parent directory) |
| `cd -` | `cd -` | Go back to previous directory (toggle) |
| `cd ../..` | `cd ../..` | Go up two levels |
| `ls` | `ls` | List files and directories |
| `clear` | `clear` | Clear the terminal screen |

### ls Flags Comparison

| Flag | Command | What It Shows |
|------|---------|--------------|
| (none) | `ls` | Names only, compact grid |
| `-l` | `ls -l` | Long format: permissions, owner, size, date |
| `-a` | `ls -a` | All files including hidden (dot-prefix) |
| `-la` | `ls -la` | Long format + hidden files |
| `-lh` | `ls -lh` | Long format + human-readable sizes (KB, MB) |
| `-lt` | `ls -lt` | Long format + sorted by modification time (newest first) |
| `-R` | `ls -R` | Recursive — shows contents of all subdirectories |

### File Read/Write Methods

| Method | What It Does | Note |
|--------|-------------|------|
| `cat file` | Display file contents | Read mode |
| `cat > file` | Write to file (overwrites) | Type content, Ctrl+D to save |
| `cat >> file` | Append to file | Adds to end, does not overwrite |
| `nano file` | Open interactive text editor | Ctrl+O save, Ctrl+X exit |
| `touch file` | Create empty file | Also updates timestamp if exists |
| `mv old new` | Move or rename file/directory | Works for both |
| `rm file` | Delete file permanently | No trash, no undo |

### Shell Operators

| Operator | What It Does | Example |
|----------|-------------|---------|
| `&&` | Run next command only if previous succeeded | `cd dir && ls` |
| `\|\|` | Run next command only if previous failed | `cd dir \|\| echo "not found"` |
| `;` | Run next command regardless of result | `pwd; ls` |
| `&` | Run command in background | `sleep 5 &` |
| `\|` | Pipe output of one command to the next | `ls \| wc -l` |

### Key Symbols

| Symbol | Meaning | Example |
|--------|---------|---------|
| `.` | Current directory | `ls .` = same as `ls` |
| `..` | Parent directory | `cd ..` goes up one level |
| `~` | Home directory | `cd ~` = go home |
| `/` | Root directory (start of absolute path) | `/etc/hosts` |
| `$` | Start of prompt (not part of path) | `$ pwd` — `$` is the shell, not a command |

---

## Common Errors and What They Mean

### "No such file or directory"
```
$ cd documents
bash: cd: documents: No such file or directory
```
Could be: wrong spelling, wrong case, wrong directory. Run `pwd` first, then `ls` to see what's actually there.

> `cd` requires the path to exist. `ls` on a non-existent path also errors — but `ls` errors tell you the path doesn't exist, while `cd` errors mean you can't navigate there.

### Case sensitivity
```
$ LS
bash: LS: command not found
```
Linux commands are lowercase. `LS`, `Ls`, `lS` are all wrong. Always use `ls`.

### Running a text file as command
```
$ myfile.txt
bash: myfile.txt: command not found
```
You meant `cat myfile.txt`. Linux doesn't know what to do with a filename unless you prefix it with a command.

### `$` is part of the prompt, not the path
```
$ cd $home      # wrong
$ cd ~          # correct
```
In tutorials, `$` shows the shell prompt. It's not part of the command. Never type it.

### cd is a command, not a path
```
$ cd path/to/dir   # correct
$ cd ~/cd path     # wrong — cd is not part of the path
```

### Typos create new files
```
$ cat > notes.tct   # typo: .tct instead of .txt
```
No error — Linux creates `notes.tct`. Always double-check filenames before pressing Enter.

---

## Lab Answers

### Level 1

**Q: What does "No such file or directory" mean?**
The path you typed doesn't exist at your current location. Either the spelling is wrong, the case is wrong, or you're in the wrong directory. Run `pwd` to confirm where you are, then `ls` to see what's available.

**Q: How do you see hidden files?**
```bash
ls -a
# or for full details:
ls -la
```
Hidden files start with a dot (`.`). Regular `ls` skips them. `-a` reveals all.

---

### Level 2

**Q: How do you track where you are as you navigate?**
Run `pwd` before and after every `cd`. It shows the full absolute path so you always know your location in the filesystem.

**Q: What's the difference between ls flags?**

| Scenario | Best Flag |
|----------|----------|
| Just need file names | `ls` |
| Need permissions and dates | `ls -l` |
| Need to see hidden files | `ls -a` |
| Need everything | `ls -la` |
| Need file sizes in readable format | `ls -lh` |
| Need to see what changed recently | `ls -lt` |

**Q: How many files in the hidden directory?**
```bash
ls -a        # shows hidden dirs (e.g. .hidden/)
ls -la .hidden/   # shows files inside
```
Answer from lab: 4 files.

**Q: What's the full path to data/secrets?**
```bash
pwd          # shows current location
# navigate down: cd data && cd secrets
pwd          # shows full path like /home/student/lab/data/secrets
```

---

### Level 3

**Q: What's the secret code?**
`NAV2026` — found in the hidden directory after using `ls -a` and `cat`.

**Q: Navigation tips for the challenge?**
- Always start with `pwd` — know where you are
- Use `ls -a` at every location — hidden files/dirs may contain the answer
- Use `cd -` to toggle between two directories quickly
- Use `cd ../..` to climb multiple levels at once
- Combine: `ls -la` shows everything in one shot

**Q: How do you troubleshoot navigation errors?**
1. `pwd` — confirm current location
2. `ls` — see what actually exists here
3. `ls -a` — check for hidden entries
4. Re-read the error message — it tells you exactly what's wrong

---

## Iron Rules Earned

> Hard-won lessons from this lab. Not rules someone told you — rules you discovered.

1. **Always run `pwd` before relative path commands** — know where you are before moving
2. **Linux is case-sensitive — always lowercase for commands** — `LS` ≠ `ls`
3. **`cd ..` = parent directory (up the tree), NOT "back" in history** — use `cd -` for "back"
4. **`>` overwrites, `>>` appends — know the difference before pressing Enter**
5. **`cat > file` = write mode, `cat file` = display mode** — the `>` changes everything
6. **Read error messages — they tell you exactly what went wrong**
