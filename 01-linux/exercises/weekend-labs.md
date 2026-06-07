# Weekend Labs - Reading Files, Search Basics, Scavenger Hunt

> Labs 3-5 from IITC DevOps course. Completed 2026-03-07.
> Score: 80/100

## Lab 3: Reading Files (cat, less, head, tail)

### Objective
Master the four core file reading commands and understand when to use each.

### Commands Learned

| Command | Purpose | Default Behavior |
|---------|---------|-----------------|
| `cat file` | Display entire file at once | Dumps everything to stdout, no pagination |
| `cat file1 file2` | Concatenate multiple files | Prints sequentially - the real meaning of "concatenate" |
| `less file` | Interactive file viewer | Opens paged view with scroll, search, navigation |
| `head file` | Display first lines | 10 lines by default |
| `head -n 20 file` | Display first N lines | Reads only N lines then stops (efficient) |
| `tail file` | Display last lines | 10 lines by default |
| `tail -n 20 file` | Display last N lines | Reads from end of file |
| `tail -f file` | Follow file in real-time | Keeps watching for new lines (essential for logs) |

### Key System Files Explored

| File | Contains | Access |
|------|----------|--------|
| `/etc/hostname` | System's network hostname | Public - any user can read |
| `/etc/os-release` | OS distribution info (name, version, ID) | Public |
| `/etc/services` | Service name to port number mappings (http=80, ssh=22) | Public |
| `/etc/shadow` | Password hashes for all users | Root only - Permission denied |

### Decision Matrix: Which Command When?

| Scenario | Best Command | Why |
|----------|-------------|-----|
| Short file (< 50 lines) | `cat` | Quick, shows everything |
| Long file (> 50 lines) | `less` | Interactive navigation, search with `/` |
| Quick preview of format/headers | `head -n 15` | Fast, reads only what's needed |
| Recent log entries | `tail -n 50` | Shows latest activity |
| Live monitoring of logs | `tail -f` | Streams new lines as they're written |
| Check multiple files quickly | `cat file1 file2` | Concatenates output |

### Performance Insight

`cat file | head -n 5` is wasteful - cat reads the entire file, then head truncates. `head -n 5 file` reads only 5 lines and stops. On a 10GB production log, this difference matters.

### Permission Model

Attempting `cat /etc/shadow` returns `Permission denied`. This is Linux's permission system in action - the file is readable only by root because it contains sensitive password hashes. This is a security feature, not a bug.

### Answers

1. **cat vs less**: cat dumps everything at once, less opens an interactive viewer with scrolling and search
2. **When head over cat**: Quick preview of file format or headers without loading the entire file
3. **When tail over less**: Checking recent log entries; `tail -f` for real-time monitoring
4. **Permission denied**: No read permission on the file - Linux security model restricting access
5. **Key lesson**: Choose tool by file size and use case. cat for short, less for long, head/tail for partial reads

---

## Lab 4: Search Basics (grep, find)

### Objective
Learn the fundamental difference: `grep` searches file **content**, `find` searches file **names/paths**.

### Commands Learned

| Command | Purpose | Key Behavior |
|---------|---------|-------------|
| `grep PATTERN file` | Search for text inside a file | Returns only matching lines, case-sensitive |
| `grep -i PATTERN file` | Case-insensitive search | Matches "Error", "ERROR", "error" equally |
| `grep -r PATTERN dir/` | Recursive search in directory | Searches all files in all subdirectories |
| `grep -n PATTERN file` | Show line numbers | Output format: `linenum:matching line` |
| `grep -c PATTERN file` | Count matching lines | Returns number only, not content |
| `find path -name "pattern"` | Find files by name | Returns full paths to matching files |
| `find path -name "*.ext"` | Find by extension (wildcard) | `*` matches any sequence of characters |
| `find path -name ".*"` | Find hidden files | Files starting with `.` are hidden in Linux |
| `find path -name "pattern" -exec cmd {} \;` | Find and execute | `{}` is replaced by each found path |

### grep vs find - The Critical Distinction

| Aspect | grep | find |
|--------|------|------|
| Searches | File **content** (what's written inside) | File **names and paths** (where files are) |
| Question it answers | "Which files contain this text?" | "Where is this file located?" |
| Output format | `filename:matching line` (with -r) | Full path to file |
| Recursive flag | `-r` | Recursive by default |
| Use case | Finding config values, error messages, secrets | Locating files by name, extension, type |

### Practical Examples from Lab

```bash
# Find all lines containing "ERROR" in a log
grep ERROR data/logs/application.log

# Count errors without seeing them
grep -c ERROR data/logs/application.log    # Output: 3

# Search for "SECRET" across entire directory tree
grep -r SECRET .
# Found: SECRET CODE: SEARCH2026 in data/secrets/hidden_info.txt

# Find all config files
find . -name "*.conf"
# Found: projects/project_alpha/config.conf, project_beta/settings.conf, project_gamma/params.conf

# Find all log files
find . -name "*.log"

# Find and read in one command
find . -name "secret_code.txt" -exec cat {} \;
```

### Suppressing Noise

`grep -r localhost /etc 2>/dev/null` - the `2>/dev/null` redirects stderr (permission denied errors) to the void, keeping output clean.

### grep Behavior When No Match

grep returns nothing and exits silently (exit code 1). No output means no matches - not an error.

### Answers

1. **grep vs find**: grep searches content inside files; find searches file names and paths
2. **When grep -r**: Searching for a string across multiple files/directories recursively
3. **When find with wildcards**: Locating files by extension or naming pattern (`*.conf`, `*.log`)
4. **Secret message**: SECRET CODE: SEARCH2026 (found in `data/secrets/hidden_info.txt`)
5. **Key lesson**: grep for content, find for names. Combined they cover any search scenario

---

## Lab 5: File System Scavenger Hunt (Capstone)

### Objective
Combine all commands from previous labs (navigation, reading, searching) in a practical treasure hunt.

### Mission Results

| Item | Value | How Found |
|------|-------|-----------|
| Password Hint | `linux2026` | `grep -i password data/logs/system.log` |
| Secret Code | `9472` | `find . -name "secret_code.txt" -exec cat {} \;` |
| Hidden Files | `.hidden_info.txt`, `.secret_notes.txt` | `ls -a hidden/` |
| CONFIG Files | `projects/project_alpha/config.yaml` (line 2) | `grep -rn "CONFIG" projects/` |
| ERROR Count | 3 | `grep -c "ERROR" data/archives/application.log` |
| Master Key | **A3F7-M5N3-7B9K-X2D8** | See breakdown below |

### Master Key Assembly

Each part required a different search technique:

| Part | Value | Location | Command Used |
|------|-------|----------|-------------|
| PART1 | A3F7 | `data/secrets/vault.txt` | `grep -r "PART1" data/secrets/` |
| PART2 | M5N3 | `projects/project_alpha/config.yaml` | `grep -r "PART2" projects/project_alpha/` |
| PART3 | 7B9K | `data/logs/backup.log` | `grep "PART3" data/logs/backup.log` |
| PART4 | X2D8 | `projects/project_beta/.env.example` | `find projects/ -name ".*" -type f -exec grep "PART4" {} +` |

### Techniques Used Across the Hunt

| Technique | Command Pattern | Purpose |
|-----------|----------------|---------|
| Navigate + read | `cd dir && cat file` | Basic file reading |
| Recursive content search | `grep -r "WORD" .` | Find text across all files |
| File name search | `find . -name "*.txt"` | Locate files by pattern |
| Find + execute | `find . -name ".*" -exec grep "PART4" {} +` | One-liner: find hidden files and search inside them |
| Hidden file listing | `ls -a` | Reveal dot-files |
| Line number search | `grep -rn "CONFIG" projects/` | Find exactly where a match is |
| Error counting | `grep -c "ERROR" file.log` | Count without displaying |
| Stderr suppression | `2>/dev/null` | Clean output by hiding permission errors |

---

## New Commands Summary (All 3 Labs Combined)

Commands added to toolkit beyond what was covered in previous exercises:

| Command | Category | Description |
|---------|----------|-------------|
| `less` | Reading | Interactive file viewer with scroll and search |
| `head -n N` | Reading | Display first N lines |
| `tail -n N` | Reading | Display last N lines |
| `tail -f` | Reading | Follow file in real-time (live logs) |
| `grep PATTERN file` | Search | Search content inside files |
| `grep -i` | Search | Case-insensitive search |
| `grep -r` | Search | Recursive directory search |
| `grep -n` | Search | Show line numbers in output |
| `grep -c` | Search | Count matching lines |
| `find path -name` | Search | Find files by name pattern |
| `find -exec {} \;` | Search | Execute command on found files |
| `find -type f` | Search | Filter: files only (not directories) |
| `mkdir -p` | File Ops | Create directory with parents |
| `touch` | File Ops | Create empty file |
| `echo "text" > file` | File Ops | Write to file (overwrite) |
| `cat > file << 'EOF'` | File Ops | Heredoc: write multi-line content to file |
| `2>/dev/null` | Shell | Redirect stderr to discard |
| `;` | Shell | Run next command regardless of previous exit code |
| `{}` (in brace expansion) | Shell | `mkdir -p dir/{a,b,c}` creates 3 subdirs |

## Iron Rules Earned

- "cat for short, less for long, head/tail for a peek" - choose the right reading tool
- "grep for content, find for names" - the fundamental search distinction
- "`cat file | head` is lazy; `head file` is correct" - efficiency matters at scale
- "Permission denied is a feature, not a bug" - Linux security model working as intended
- "Hidden files start with a dot - `ls -a` reveals all" - nothing is truly hidden if you know where to look
