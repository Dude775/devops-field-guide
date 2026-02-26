# print() - sep and end Parameters

## TL;DR

`print()` has two parameters that control formatting: `sep` (what goes between arguments) and `end` (what goes after the last argument). Mastering these gives precise control over output formatting without string concatenation.

## Full Picture

### Basic `print()`

```python
print("Hello", "World")
# Output: Hello World
```

`print()` takes any number of arguments, converts them to strings, and outputs them separated by spaces with a newline at the end.

### `sep` - Separator Between Arguments

Controls what character(s) appear **between** arguments. Default is a single space `" "`.

```python
print("2026", "02", "26", sep="-")
# Output: 2026-02-26

print("usr", "local", "bin", sep="/")
# Output: usr/local/bin

print("A", "B", "C", sep="")
# Output: ABC

print("item1", "item2", "item3", sep=", ")
# Output: item1, item2, item3
```

### `end` - What Comes After

Controls what character(s) appear **after** the last argument. Default is `"\n"` (newline).

```python
print("Loading", end="")
print("...")
# Output: Loading...

print("Step 1", end=" -> ")
print("Step 2", end=" -> ")
print("Done")
# Output: Step 1 -> Step 2 -> Done
```

### Combining `sep` and `end`

```python
print("2026", "02", "26", sep="-", end=" | ")
print("10", "30", "00", sep=":")
# Output: 2026-02-26 | 10:30:00
```

## Why It Matters for DevOps

Output formatting is the foundation of:

- **Logging**: structured log messages with consistent separators
- **CLI tools**: status lines, progress indicators, formatted tables
- **Monitoring output**: timestamps, metrics, delimited data
- **Script output**: CSV generation, report formatting

## Key Takeaways

- `sep` controls what goes **between** arguments (default: space)
- `end` controls what goes **after** all arguments (default: newline)
- `sep=""` joins arguments with nothing between them
- `end=""` prevents the newline, so the next `print()` continues on the same line
- Both can be combined for precise output control

## Real-World Example

Building a status line for a deployment script:

```python
print("Deploy", "v2.1.0", "production", sep=" | ", end="\n")
# Output: Deploy | v2.1.0 | production
```
