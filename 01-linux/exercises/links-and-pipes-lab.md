# Links & Pipes Labs (Labs 6-7) — 100/100

## Lab Overview

Three hands-on labs covering fundamental Linux concepts:
- **Hard Links** — Multiple names pointing to the same inode
- **Soft Links** — Symbolic pointers to file paths
- **Pipes & Redirection** — STDIN, STDOUT, sort, wc, and pipelines

## Commands Learned

| Command | What It Does | Example |
|---------|-------------|---------|
| `ln` | Create hard link | `ln data.txt data_link` |
| `ln -s` | Create soft (symbolic) link | `ln -s notes.txt notes_link` |
| `ls -la` | List files with link details | `ls -la` |
| `ls -i` | Show inode numbers | `ls -i` |
| `stat` | Detailed file/inode info | `stat data.txt` |
| `sort` | Sort lines alphabetically | `sort names.txt` |
| `wc -l` | Count lines | `wc -l names.txt` |
| `wc -w` | Count words | `wc -w names.txt` |
| `wc -c` | Count characters/bytes | `wc -c names.txt` |
| `>` | Redirect STDOUT to file | `sort names.txt > sorted.txt` |
| `<` | Feed file via STDIN | `wc -l < names.txt` |
| `\|` | Pipe STDOUT to next command | `cat file \| sort \| wc -l` |

---

## Lab 6A: Hard Links

### Key Exercises

**Creating hard links and observing inode sharing:**

```bash
echo "hello world" > data.txt
ln data.txt data_link
ln data.txt data_link2
ls -i
```

All three names share the same inode number. ref count = 3.

**Deletion behavior — ref count countdown:**

```
data.txt      --\
data_link     ---+-->  inode 12644  -->  Data Blocks
data_link2    --/     (ref count: 3)

rm data.txt   ->  ref count: 2  ->  data alive
rm data_link  ->  ref count: 1  ->  data alive
rm data_link2 ->  ref count: 0  ->  data dead
```

### Key Observations

- Hard link = additional name for the same inode. There is no "original" and "copy"
- `rm` = `unlink` — removes a name, not the data
- Data is only deleted when ALL names are removed (ref count = 0)
- Hard links cannot point to directories
- Hard links cannot cross filesystem boundaries

---

## Lab 6B: Soft Links

### Key Exercises

**Creating soft links:**

```bash
echo "This is my notes file" > notes.txt
ln -s notes.txt notes_link
ls -la
```

Output shows: `lrwxrwxrwx ... notes_link -> notes.txt`

**Reading and writing through soft link:**

```bash
cat notes_link                          # reads original file
echo "Added via soft link" >> notes_link  # modifies original file
cat notes.txt                           # change is visible
```

**Soft link to directory (not possible with hard links):**

```bash
mkdir projects
echo "Project 1 content" > projects/project1.txt
ln -s projects projects_link
ls projects_link/                       # shows project1.txt
```

**Cross-directory link (must use absolute path):**

```bash
ln -s ~/softlink_lab/notes.txt /tmp/notes_link
cat /tmp/notes_link                     # works
```

**Broken (dangling) symlink:**

```bash
rm notes.txt
cat notes_link                          # No such file or directory
ls -la                                  # link still exists, but target is gone
```

**Multiple soft links to same target:**

```bash
echo "Linux is awesome" > linux.txt
ln -s linux.txt linux_link1
ln -s linux.txt linux_link2
echo "New line added" >> linux.txt
cat linux_link1; cat linux_link2        # both show updated content
```

### Key Observations

- Soft link is a separate file containing a path string (size = length of path)
- Soft link does NOT increase ref count on the target inode
- Deleting the target breaks the link (dangling symlink) — opposite of hard link behavior
- Soft links work on directories and across filesystems
- Deleting a soft link never affects the target
- Identify soft links: `l` at start of permissions + `->` arrow in `ls -la`

### Hard Link vs Soft Link — Decision Matrix

| Criteria | Hard Link | Soft Link |
|----------|-----------|-----------|
| Points to | inode | path (string) |
| Delete original | data survives (ref count > 0) | link breaks |
| Directories | not supported | supported |
| Cross-filesystem | not supported | supported |
| Identify in ls | same inode number | `l` prefix + `->` arrow |
| Link size | same as original | length of path string |
| Use case | backup-safe references | shortcuts, directory links |

---

## Lab 7: Pipes & Redirection

### Key Exercises

**STDOUT redirection — sort and save:**

```bash
echo -e "David\nAnna\nMoshe\nYossi\nLea" > names.txt
sort names.txt > sorted_names.txt
cat sorted_names.txt
```

**wc — counting lines, words, characters:**

```bash
wc -l names.txt    # 5 names.txt (with filename)
wc -w names.txt    # 5 names.txt
wc -c names.txt    # 27 names.txt (includes \n characters)
```

**STDIN `<` vs argument — the subtle difference:**

```bash
wc -l names.txt      # Output: 5 names.txt  (filename shown)
wc -l < names.txt    # Output: 5            (no filename)
```

With `<`, the shell opens the file and streams it to STDIN. The command never sees the filename.

**Pipes — chaining commands:**

```bash
cat names.txt | wc -l          # pipe to count
cat names.txt | sort           # pipe to sort
sort names.txt | wc -l         # sort then count
cat cities.txt | sort | wc -l  # 3-stage pipeline
```

**STDIN `<` with sort:**

```bash
sort < cities.txt              # shell feeds file to sort via STDIN
```

### Key Observations

- `>` redirects STDOUT to a file (overwrites). `>>` appends
- `<` feeds a file to STDIN — command doesn't know the filename
- `|` connects STDOUT of left command to STDIN of right command
- `<` feeds from a file, `|` feeds from another command's output — both go to STDIN
- Every Linux command is a building block. Pipes connect them into a processing pipeline
- `cat file | sort` = `sort file` — the `cat` is redundant (Useless Use of Cat), but useful for learning pipelines
- `wc -c` counts bytes including `\n` newline characters — that's why count is higher than visible characters

### Iron Rules

1. **Soft links break on target deletion** — always verify target exists before relying on symlinks
2. **Use absolute paths for cross-directory soft links** — relative paths resolve from the link's location, not yours
3. **STDIN has no filename** — when piping or using `<`, the receiving command cannot know the source
4. **`rm` on a symlink is safe** — it only removes the pointer, never the target
5. **Hard link ref count is your safety net** — data survives until the last name is removed
