# Exercise: Log File Generator

## The Task

Generate 25 log files using a bash `for` loop, then verify the count.

## The Solution

```bash
for i in $(seq 1 25); do echo "Log entry $i - $(date)" > log_$i.txt; done
```

### Verification

```bash
ls log_*.txt | wc -l
# Output: 25
```

## Breaking It Down

| Part | What It Does |
|------|-------------|
| `for i in $(seq 1 25)` | Loop variable `i` takes values 1 through 25 |
| `$(seq 1 25)` | Command substitution - runs `seq` and inserts its output |
| `do ... done` | Loop body delimiters |
| `echo "Log entry $i - $(date)"` | Create a string with the loop counter and current timestamp |
| `$i` | Variable expansion - replaced with current loop value |
| `$(date)` | Command substitution - inserts current date/time |
| `> log_$i.txt` | Redirect output to a file named `log_1.txt`, `log_2.txt`, etc. |

### The Verification Line

```bash
ls log_*.txt | wc -l
```

- `ls log_*.txt` - List all files matching the glob pattern
- `|` - Pipe the list to the next command
- `wc -l` - Count lines (one file per line = file count)

## Why This Pattern Matters

This is not just an exercise. The same loop structure is used for:

- **Generating test data**: create hundreds of sample files for load testing
- **Bulk operations**: rename, move, or process files in batch
- **Log rotation testing**: simulate log output across multiple files
- **Infrastructure scripts**: create multiple config files from a template

The pattern scales: change `25` to `10000` and the logic is identical.

## Sample Output

```
# log_1.txt contains:
Log entry 1 - Wed Feb 26 10:30:00 UTC 2026

# log_25.txt contains:
Log entry 25 - Wed Feb 26 10:30:00 UTC 2026
```
