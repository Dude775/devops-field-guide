# Heredoc and Redirection

## Output Redirection: `>`

Redirects a command's output to a file, **overwriting** any existing content.

```bash
echo "Hello World" > greeting.txt
```

If `greeting.txt` exists, its contents are replaced. If it doesn't exist, it's created.

## Pipe: `|`

Sends the output of one command as input to another. Data flows left to right.

```bash
ls log_*.txt | wc -l
```

`ls` outputs filenames → `wc -l` counts the lines → you get the file count.

## Heredoc: `cat > file << 'EOF'`

A heredoc (here document) lets you write multi-line content directly into a file without opening an editor.

```bash
cat > config.txt << 'EOF'
server_name=myapp
port=8080
environment=production
EOF
```

### How It Works

1. `cat > config.txt` - `cat` reads from stdin and redirects to `config.txt`
2. `<< 'EOF'` - Everything between this line and the closing `EOF` is the input
3. Content lines are written as-is
4. `EOF` on its own line ends the input

### Why Quotes Around `'EOF'` Matter

```bash
# WITH quotes: literal text, no expansion
cat > file.txt << 'EOF'
Value is $HOME
EOF
# File contains: Value is $HOME

# WITHOUT quotes: variables get expanded
cat > file.txt << EOF
Value is $HOME
EOF
# File contains: Value is /home/david
```

Use `'EOF'` (quoted) when you want the exact text. Use `EOF` (unquoted) when you want variables to resolve.

## Practical Use

Heredocs let you create files without `nano` or `vim`. This is especially useful in:

- **Scripts**: creating config files programmatically
- **Dockerfiles**: writing config files during image build
- **CI/CD pipelines**: generating files on the fly
- **Remote sessions**: when you just need to quickly create a file

## Quick Reference

| Syntax | What It Does |
|--------|-------------|
| `>` | Redirect output to file (overwrite) |
| `>>` | Redirect output to file (append) |
| `\|` | Pipe output to next command |
| `<< 'EOF'` | Heredoc start (no variable expansion) |
| `<< EOF` | Heredoc start (with variable expansion) |
