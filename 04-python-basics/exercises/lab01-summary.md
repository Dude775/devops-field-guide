# Lab 01 Summary: Print Basics

## What Was Practiced

- Basic `print()` with single and multiple arguments
- `sep` parameter for controlling separators between arguments
- `end` parameter for controlling line endings
- Combining `sep` and `end` for formatted output
- Building a practical status line display

## Key Patterns

| Pattern | Use Case |
|---------|----------|
| `print("a", "b", sep="-")` | Joining values with a delimiter |
| `print("text", end="")` | Continuing output on the same line |
| `print(a, b, c, sep=",")` | Quick CSV-style output |
| `print("...", end=" \| ")` | Building tabular displays |

## Connection to Real-World Use

Output formatting with `print()` is the starting point for:

- **Logging**: structured messages with timestamps and severity levels
- **CLI tools**: progress bars, status indicators, formatted reports
- **Debug output**: inspecting variable values during development
- **Script output**: generating data in specific formats (CSV, TSV, logs)

## Files

- [`welcome.py`](../code/lab01-print-basics/welcome.py) - Basic print usage
- [`print_sep.py`](../code/lab01-print-basics/print_sep.py) - Separator parameter
- [`print_end.py`](../code/lab01-print-basics/print_end.py) - End parameter
- [`print_sep_end.py`](../code/lab01-print-basics/print_sep_end.py) - Both combined
- [`status_line.py`](../code/lab01-print-basics/status_line.py) - Practical application
