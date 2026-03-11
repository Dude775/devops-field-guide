# Core Commands Reference

Commands learned during the Linux module, organized by category.

## Reading Files

| Command | What It Does | Example |
|---------|-------------|---------|
| `cat` | Display entire file / concatenate multiple files | `cat config.txt` or `cat file1 file2` |
| `less` | Interactive file viewer (scroll, search, navigate) | `less /etc/services` then `q` to exit |
| `head` | Display first lines (default 10) | `head -n 20 app.log` |
| `tail` | Display last lines (default 10) | `tail -n 50 app.log` |
| `tail -f` | Follow file in real-time | `tail -f /var/log/syslog` |

## Searching

| Command | What It Does | Example |
|---------|-------------|---------|
| `grep PATTERN file` | Search for text inside a file | `grep ERROR app.log` |
| `grep -i` | Case-insensitive search | `grep -i error app.log` |
| `grep -r` | Recursive search in directory tree | `grep -r "TODO" .` |
| `grep -n` | Show line numbers with matches | `grep -n "CONFIG" settings.yaml` |
| `grep -c` | Count matching lines | `grep -c ERROR app.log` |
| `find path -name` | Find files by name pattern | `find /etc -name "*.conf"` |
| `find -type f` | Filter to files only | `find . -name ".*" -type f` |
| `find -exec` | Execute command on results | `find . -name "*.log" -exec grep ERROR {} +` |

## System Administration

| Command | What It Does | Example |
|---------|-------------|---------|
| `sudo` | Run command as root (superuser) | `sudo apt install curl -y` |
| `apt install` | Install a package from repositories | `sudo apt install openssh-server -y` |
| `apt update` | Refresh the list of available packages | `sudo apt update` |

## Networking

| Command | What It Does | Example |
|---------|-------------|---------|
| `ip a` | Show network interfaces and IP addresses | `ip a` shows `enp0s3: 10.0.2.15` |
| `ssh` | Open a secure shell session to a remote host | `ssh david@127.0.0.1 -p 2222` |
| `curl -L` | Download from a URL, following redirects | `curl -L https://example.com/file.tar.gz` |
| `nmcli device status` | Show network interface status (managed by NetworkManager) | `nmcli device status` |

## File Operations

| Command | What It Does | Example |
|---------|-------------|---------|
| `cd` | Change directory | `cd project-folder` |
| `ls -la` | List all files including hidden, with details | `ls -la` shows permissions, sizes, dates |
| `ls -a` | List all files including hidden (short format) | `ls -a` reveals dot-files |
| `tar -xz` | Extract a gzip-compressed tar archive | `tar -xz` (usually piped from curl) |

## File Management

| Command | What It Does | Example |
|---------|-------------|---------|
| `mkdir` | Create a single directory | `mkdir projects` |
| `mkdir -p` | Create nested directories (with parents) | `mkdir -p app/src/tests` |
| `touch` | Create empty file or update timestamp | `touch notes.txt` |
| `cp src dest` | Copy file (independent duplicate) | `cp config.sh config_backup.sh` |
| `cp f1 f2 dir/` | Copy multiple files to directory | `cp main.sh utils.sh backups/` |
| `mv src dest` | Move file to new location | `mv file.txt archive/` |
| `mv old new` | Rename file | `mv draft.txt final.txt` |
| `rm file` | Delete file permanently (no undo) | `rm temp.txt` |
| `rmdir dir` | Delete empty directory only | `rmdir old_folder` |
| `rm -r dir` | Delete directory and all contents | `rm -r build/` (use with caution) |
| `find path -type f` | Find all files recursively | `find linux_lab -type f` |
| `find path -type f \| sort` | Find and sort all files | `find . -type f \| sort` |

## Links

| Command | What It Does | Example |
|---------|-------------|---------|
| `ln` | Create hard link | `ln original.txt hardlink.txt` |
| `ln -s` | Create symbolic (soft) link | `ln -s target.txt symlink.txt` |
| `ls -i` | Show inode numbers | `ls -i` |
| `stat` | Show detailed inode info | `stat file.txt` |

## Pipes & Redirection

| Command | What It Does | Example |
|---------|-------------|---------|
| `>` | Redirect STDOUT to file (overwrite) | `echo "hi" > file.txt` |
| `>>` | Redirect STDOUT to file (append) | `echo "more" >> file.txt` |
| `echo "x" \| sudo tee file` | Write to root-owned file (sudo-safe redirect) | `echo "report" \| sudo tee /opt/report.txt` |
| `echo "x" \| sudo tee -a file` | Append to root-owned file | `echo "line" \| sudo tee -a /opt/report.txt` |
| `<` | Feed file to STDIN | `wc -l < file.txt` |
| `\|` | Pipe STDOUT to next command | `cat file \| sort \| wc -l` |
| `2>` | Redirect STDERR to file (overwrite) | `ls /fake 2> errors.txt` |
| `2>>` | Redirect STDERR to file (append) | `ls /fake 2>> errors.txt` |
| `2>&1` | Redirect STDERR to same destination as STDOUT | `command > all.txt 2>&1` |
| `> f1 2> f2` | Split STDOUT and STDERR to separate files | `cmd > out.txt 2> err.txt` |
| `sort` | Sort lines alphabetically | `sort names.txt` |
| `wc` | Count lines/words/chars | `wc -l file.txt` |

## Text and Output

| Command | What It Does | Example |
|---------|-------------|---------|
| `echo` | Print text to terminal or redirect to file | `echo "Log entry" > file.txt` |
| `seq` | Generate a sequence of numbers | `seq 1 25` prints 1 through 25 |
| `wc -l` | Count lines in input | `ls *.txt \| wc -l` |

## Shell Operators

| Operator | What It Does | Example |
|----------|-------------|---------|
| `>` | Redirect output to file (overwrites) | `echo "text" > file.txt` |
| `\|` | Pipe: send output of one command as input to another | `ls \| wc -l` |
| `&&` | Run next command only if previous succeeded | `cd dir && cat file.md` |
| `;` | Run next command regardless of previous result | `cat bad_file; echo "continues"` |
| `2>/dev/null` | Redirect stderr to discard (suppress errors) | `grep -r text /etc 2>/dev/null` |
| `cat > file << 'EOF'` | Heredoc: write multi-line content to file | See heredoc-and-redirection.md |
| `{a,b,c}` | Brace expansion: generates multiple arguments | `mkdir {src,lib,docs}` |
| `for/do/done` | Loop construct in bash | `for i in $(seq 1 5); do echo $i; done` |

## Process Management

| Command | What It Does | Example |
|---------|-------------|---------|
| `pgrep <name>` | Get PIDs of processes by name (searches process name) | `pgrep node` |
| `pgrep -f <pattern>` | Get PIDs by full command line (use for scripts) | `pgrep -f immortal` |
| `ps` | Snapshot of current session processes | `ps` |
| `ps -ef` | All processes with full details (UID, PID, PPID, CMD) | `ps -ef` |
| `ps aux` | All processes BSD-style (CPU, MEM, STAT) | `ps aux` |
| `ps -p PID` | Info on specific process | `ps -p 1024` |
| `ps -pf PID` | Specific process with full details | `ps -pf 1024` |
| `ps -C name` | Find processes by command name | `ps -C nginx` |
| `ps -u user` | Processes by user | `ps -u www-data` |
| `ps --forest` | Tree view of parent/child relationships | `ps -ef --forest` |
| `ps -eLf` | All threads in full format | `ps -eLf` |
| `ps -o fields` | Custom output format | `ps -eo pid,ppid,%cpu,%mem,cmd` |
| `ps aux --sort=-%cpu` | Sort by CPU usage (descending) | `ps aux --sort=-%cpu` |
| `top` | Real-time process monitor | `top` |
| `htop` | Enhanced real-time monitor (install separately) | `htop` |

## Signals & Kill

| Command | What It Does | Example |
|---------|-------------|---------|
| `kill PID` | Send SIGTERM (graceful stop) | `kill 1234` |
| `kill -9 PID` | Send SIGKILL (force kill) | `kill -9 1234` |
| `kill -STOP PID` | Freeze process (stays in memory) | `kill -STOP 1234` |
| `kill -CONT PID` | Resume frozen process | `kill -CONT 1234` |
| `kill -HUP PID` | Reload config without restart | `kill -HUP 1234` |
| `kill -l` | List all available signals | `kill -l` |

## systemd & Services

| Command | What It Does | Example |
|---------|-------------|---------|
| `systemctl daemon-reload` | Reload unit files after editing (required after every change) | `sudo systemctl daemon-reload` |
| `systemctl status` | Show service status, PID, memory | `systemctl status nginx` |
| `systemctl start` | Start a service | `sudo systemctl start nginx` |
| `systemctl stop` | Stop a service gracefully | `sudo systemctl stop nginx` |
| `systemctl restart` | Stop and start a service | `sudo systemctl restart nginx` |
| `systemctl reload` | Reload config without stopping | `sudo systemctl reload nginx` |
| `systemctl enable` | Start service on boot | `sudo systemctl enable nginx` |
| `systemctl disable` | Don't start service on boot | `sudo systemctl disable nginx` |
| `systemctl is-active` | Quick check if running | `systemctl is-active nginx` |
| `systemctl is-enabled` | Quick check if enabled on boot | `systemctl is-enabled nginx` |
| `systemctl list-units` | List all services | `systemctl list-units --type=service` |

## Logs (journalctl)

| Command | What It Does | Example |
|---------|-------------|---------|
| `journalctl` | All systemd logs | `journalctl` |
| `journalctl -n N` | Last N log messages | `journalctl -n 20` |
| `journalctl -f` | Follow logs in real-time | `journalctl -f` |
| `journalctl -u` | Logs for specific service | `journalctl -u ssh` |
| `journalctl -u service -f` | Follow specific service live | `journalctl -u ssh -f` |
| `journalctl -b` | Logs since current boot | `journalctl -b` |
| `journalctl -b -1` | Logs from previous boot | `journalctl -b -1` |
| `journalctl -p` | Filter by priority (and above) | `journalctl -p err` |
| `journalctl --since/--until` | Filter by time range | `journalctl --since "1 hour ago"` |
| `journalctl -o short-iso` | ISO timestamp format | `journalctl -o short-iso` |
| `journalctl -xe` | Recent events with explanations | `journalctl -xe` |

## User Management

| Command | What It Does | Example |
|---------|-------------|---------|
| `whoami` | Display current user | `whoami` |
| `sudo adduser <name>` | Create user (friendly, interactive) | `sudo adduser alice` |
| `sudo useradd <name>` | Create user (bare-bones) | `sudo useradd bob` |
| `su - <name>` | Switch to user with full login shell | `su - alice` |
| `passwd <name>` | Set/change user password | `sudo passwd bob` |
| `chown <user>:<group> <path>` | Change file/directory ownership | `sudo chown bob:bob /home/bob` |
| `chown -R <user>:<group> <path>` | Recursive ownership change | `sudo chown -R root:devteam /opt/project` |
| `chmod +x <file>` | Make file executable | `chmod +x ~/immortal.sh` |
| `chmod <mode> <path>` | Set file/directory permissions | `sudo chmod 770 /opt/project` |
| `chmod -R <mode> <path>` | Recursive permission change | `sudo chmod -R 770 /opt/project` |
| `groupadd <name>` | Create a new group | `sudo groupadd devteam` |
| `usermod -aG <group> <user>` | Add user to group (append, keeps existing groups) | `sudo usermod -aG devteam dev1` |
| `cut -d<delim> -f<field>` | Extract fields from structured text | `cut -d: -f1 /etc/passwd` |

## Command Categories Quick Reference

| Need To... | Use |
|------------|-----|
| Read a short file | `cat` |
| Read a long file | `less` |
| Preview beginning of file | `head -n N` |
| Preview end of file / monitor logs | `tail -n N` / `tail -f` |
| Search text inside files | `grep` (add `-r` for recursive, `-i` for case-insensitive) |
| Find files by name | `find path -name "pattern"` |
| Create directories | `mkdir -p` |
| Install software | `sudo apt install` |
| Remote connect | `ssh user@host` |
| Download files | `curl -L url` |
