# Core Commands Reference

Commands learned during the Linux environment setup and first exercises.

| Command | What It Does | Example |
|---------|-------------|---------|
| `sudo` | Run command as root (superuser) | `sudo apt install curl -y` |
| `apt install` | Install a package from repositories | `sudo apt install openssh-server -y` |
| `apt update` | Refresh the list of available packages | `sudo apt update` |
| `ip a` | Show network interfaces and IP addresses | `ip a` → shows `enp0s3: 10.0.2.15` |
| `ssh` | Open a secure shell session to a remote host | `ssh david@127.0.0.1 -p 2222` |
| `curl -L` | Download from a URL, following redirects | `curl -L https://example.com/file.tar.gz` |
| `tar -xz` | Extract a gzip-compressed tar archive | `tar -xz` (usually piped from curl) |
| `cat` | Display file contents / create files with heredoc | `cat TASKS.md` |
| `cd` | Change directory | `cd project-folder` |
| `ls -la` | List all files including hidden, with details | `ls -la` → shows permissions, sizes, dates |
| `echo` | Print text to terminal or redirect to file | `echo "Log entry" > file.txt` |
| `seq` | Generate a sequence of numbers | `seq 1 25` → prints 1 through 25 |
| `wc -l` | Count lines in input | `ls *.txt \| wc -l` → count of matching files |
| `>` | Redirect output to file (overwrites) | `echo "text" > file.txt` |
| `\|` | Pipe: send output of one command as input to another | `ls \| wc -l` |
| `&&` | Run next command only if previous succeeded | `cd dir && cat file.md` |
| `for/do/done` | Loop construct in bash | `for i in $(seq 1 5); do echo $i; done` |

## Command Categories

### System Administration
`sudo`, `apt install`, `apt update`

### Networking
`ip a`, `ssh`, `curl`

### File Operations
`cat`, `cd`, `ls -la`, `tar -xz`

### Text & Output
`echo`, `seq`, `wc -l`

### Flow Control
`>` (redirect), `|` (pipe), `&&` (chain), `for/do/done` (loop)
