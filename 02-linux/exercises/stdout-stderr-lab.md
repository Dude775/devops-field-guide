# STDOUT / STDERR Practice Lab

> Linux Hands-On Lab. Completed 2026-03-08.
> Score: 100/100

## Lab Overview

Practice output redirection — understanding STDOUT (fd 1) and STDERR (fd 2) as separate channels, and how to redirect each one independently or combine them.

## Commands Learned

| Syntax | What It Does | Example |
|--------|-------------|---------|
| `>` | Redirect STDOUT to file (overwrite) | `ls > list.txt` |
| `>>` | Redirect STDOUT to file (append) | `echo "more" >> log.txt` |
| `2>` | Redirect STDERR to file (overwrite) | `ls /fake 2> errors.txt` |
| `2>>` | Redirect STDERR to file (append) | `ls /fake 2>> errors.txt` |
| `> file 2>&1` | Redirect both STDOUT and STDERR to one file | `command > all.txt 2>&1` |
| `> file1 2> file2` | Split streams to separate files | `command > out.txt 2> err.txt` |

---

## Exercises

### Exercise 1 — Basic STDOUT redirect

```bash
echo "Hello World" > hello.txt
cat hello.txt
```

Output: `Hello World`

### Exercise 2 — Overwrite vs append

```bash
echo "Line 1" > file.txt
echo "Line 2" > file.txt
cat file.txt
```

Output: `Line 2` — `>` overwrites every time.

```bash
echo "Line 1" > file.txt
echo "Line 2" >> file.txt
cat file.txt
```

Output: `Line 1` then `Line 2` — `>>` preserves and appends.

### Exercise 3 — ls redirect

```bash
ls > list.txt
cat list.txt
```

**Key observation:** `list.txt` appears in its own output. `>` creates the target file **before** the command executes.

### Exercise 4 — STDERR goes to screen when only STDOUT is redirected

```bash
ls /nonexistent > output.txt
```

`output.txt` is empty. The error message still appears on screen — `>` only captures STDOUT (fd 1), not STDERR (fd 2).

### Exercise 5 — Redirect STDERR only

```bash
ls /nonexistent 2> errors.txt
cat errors.txt
```

Error message captured in `errors.txt`. Screen shows nothing — STDERR was redirected, and there was no STDOUT.

### Exercise 6 — STDOUT to screen when only STDERR is redirected

```bash
ls /home 2> errors.txt
```

Directory listing appears on screen (STDOUT). `errors.txt` is empty because there were no errors.

### Exercise 7 — Mixed output: valid + invalid

```bash
ls /home /nonexistent > output.txt 2> errors.txt
cat output.txt    # directory listing for /home
cat errors.txt    # error about /nonexistent
```

Streams split cleanly to separate files.

### Exercise 8 — Combine both streams to one file

```bash
ls /home /nonexistent > all.txt 2>&1
cat all.txt
```

Both STDOUT and STDERR captured in `all.txt`. Screen is completely clean.

### Exercise 9 — Append STDERR

```bash
ls /fake1 2> errors.txt
ls /fake2 2>> errors.txt
cat errors.txt
```

Two error messages — first from overwrite, second appended.

### Exercise 10 — Redirect in a loop

```bash
for dir in /home /nonexistent /tmp /fake; do
  ls $dir
done > output.txt 2> errors.txt
```

All STDOUT in `output.txt`, all STDERR in `errors.txt`.

### Exercise 11 — grep with redirect

```bash
grep "root" /etc/passwd > found.txt 2> grep_errors.txt
cat found.txt
```

Matching lines in `found.txt`, any errors in `grep_errors.txt`.

### Exercise 12 — find with STDERR suppression

```bash
find /etc -name "*.conf" 2>/dev/null
```

Only results shown — permission denied errors silenced.

### Exercise 13 — Redirect to /dev/null

```bash
ls /nonexistent 2>/dev/null
```

Nothing on screen. Error swallowed by `/dev/null`.

### Exercise 14 — Both streams to /dev/null

```bash
ls /home /nonexistent > /dev/null 2>&1
```

Complete silence. Both STDOUT and STDERR discarded.

### Exercise 15 — cat with redirect

```bash
cat /etc/hostname > hostname.txt 2> cat_errors.txt
cat hostname.txt
```

### Exercise 16 — Overwrite confirmation

```bash
echo "First" > test.txt
echo "Second" > test.txt
cat test.txt
```

Output: `Second` — confirming `>` always overwrites.

### Exercise 17 — Append confirmation

```bash
echo "Line A" > test.txt
echo "Line B" >> test.txt
echo "Line C" >> test.txt
cat test.txt
```

Output: all three lines — confirming `>>` always appends.

### Exercise 18 — STDERR append from multiple commands

```bash
ls /fake1 2> err.txt
ls /fake2 2>> err.txt
ls /fake3 2>> err.txt
wc -l err.txt
```

Three error lines accumulated.

### Exercise 19 — Combined redirect with real commands

```bash
echo "Starting backup..." > backup.log
ls /important/data >> backup.log 2>&1
echo "Backup complete." >> backup.log
cat backup.log
```

Log shows start message, error from missing directory, and completion — simulating real-world logging.

### Exercise 20 — Order matters

```bash
# This works — STDERR follows STDOUT to the file:
ls /home /nonexistent > all.txt 2>&1

# This does NOT work as expected:
ls /home /nonexistent 2>&1 > all.txt
```

**Key observation:** `2>&1` means "send STDERR to wherever STDOUT is pointing **right now**." In the second form, STDOUT still points to the terminal when `2>&1` executes, so STDERR goes to the screen. Order matters.

---

## Key Observations

- **STDOUT (fd 1) and STDERR (fd 2) are separate channels** — they can be redirected independently
- **`>` only captures STDOUT** — STDERR still appears on screen unless explicitly redirected
- **`2>` only captures STDERR** — STDOUT still appears on screen
- **`> file 2>&1` captures everything** — screen is completely clean
- **`>` overwrites every time, `>>` preserves and appends** — know the difference or lose data
- **`>` creates the target file before the command runs** — `ls > list.txt` includes `list.txt` in its own output
- **Order matters for `2>&1`** — `> file 2>&1` works, `2>&1 > file` does NOT work as expected

## Iron Rules

1. **"In production, always use `command > log.txt 2>&1` to capture everything"** — crontab, systemd services, and background processes all use this pattern
2. **"`>` creates the file before the command runs"** — be aware of this when redirecting `ls` output
3. **"STDOUT and STDERR are separate channels — redirect each intentionally"** — ignoring STDERR means missing errors silently
4. **"`>` overwrites, `>>` appends — no exceptions"** — if you need history, always use `>>`
5. **"Order matters: `> file 2>&1` works, `2>&1 > file` does not"** — `2>&1` captures STDERR to wherever STDOUT points at that moment

## Real-World Patterns

| Context | Pattern | Why |
|---------|---------|-----|
| Crontab jobs | `command > /var/log/job.log 2>&1` | Capture all output for debugging |
| Systemd services | `StandardOutput=file:/var/log/app.log` | Same concept, different syntax |
| Background processes | `./server > server.log 2>&1 &` | Detach from terminal, log everything |
| CI/CD pipelines | `make build > build.log 2>&1` | Full build log for analysis |
| Quiet scripts | `command > /dev/null 2>&1` | Silence everything — only exit code matters |
