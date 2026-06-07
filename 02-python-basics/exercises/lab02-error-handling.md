# Lab 02 Summary: Error Handling

## What Was Practiced

- `try`, `except`, `else`, `finally` block structure
- Catching specific exception types vs bare `except`
- `raise` for throwing exceptions manually
- `as e` for accessing the exception object
- Custom exception classes
- Input validation loop with `while True` + `break`

---

## Keywords vs Classes

| Category | Examples | What they are |
|----------|----------|---------------|
| Keywords | `try`, `except`, `raise`, `else`, `finally` | Built into Python like `if`/`for` — not objects |
| Exception classes | `ValueError`, `TypeError`, `ZeroDivisionError` | Built-in objects that can be raised and caught |

---

## Block Structure Reference

| Block | When it runs | Purpose |
|-------|-------------|---------|
| `try` | Always — first | The risky code |
| `except <Type>` | Only if that exception was raised | Handle the failure |
| `else` | Only if NO exception occurred | Code that should run on success |
| `finally` | Always — last | Cleanup (files, status, resources) |

---

## Common Exception Classes

| Class | Raised when |
|-------|------------|
| `ValueError` | Wrong value type (e.g. `int("hello")`) |
| `TypeError` | Wrong data type for operation |
| `ZeroDivisionError` | Division by zero |
| `FileNotFoundError` | File path doesn't exist |
| `IndexError` | List index out of range |
| `KeyError` | Dict key doesn't exist |

---

## Q&A from the Session

### 1. What is Error Handling?
Python runs line by line. When it hits something it can't execute, it throws an exception and stops. Error handling lets you catch that failure and respond gracefully instead of crashing the entire script.

### 2. Keywords vs Classes
- `try`, `except`, `raise`, `else`, `finally` are **keywords** — built into Python like `if`/`for`/`while`
- `ValueError`, `TypeError`, `ZeroDivisionError` are **classes** — objects that represent error types
- Keywords are not functions, not objects. Classes are objects that can be raised and caught.

### 3. The three roles of exception classes (e.g. `ValueError`)
- Python throws them automatically: `int("hello")` → `ValueError`
- You catch them: `except ValueError:`
- You throw them yourself: `raise ValueError("message")`

### 4. What is `as e`?
`except ValueError as e:` stores the exception object in variable `e`.  
The object contains the error message. `e` is just a convention — could be named anything.  
`print(e)` prints the message that was passed to `raise`.

### 5. Why catch specific types vs bare `except`?
- `except:` catches everything silently — hides bugs
- `except ValueError:` catches only that type — you know exactly what happened
- **Analogy**: bare `except` = general doctor who treats everything without diagnosis. `except ValueError` = specialist.

### 6. Why does `else` exist? (not just putting code inside `try`)
Code in `else` is **not** inside the `try` scope.  
If the `else` block raises an error, it **won't** be caught by the `except` above it.  
Clean separation: `try` = attempt, `except` = failure, `else` = success.

### 7. `finally` — always runs
Runs after `try` + `except` + `else` regardless of outcome.  
Used for cleanup: closing files, printing status, releasing resources.  
In a `while` loop — runs on **every** iteration.

### 8. `raise` — you throw the error yourself
Python won't throw an error for `age = -30` (mathematically valid).  
You add logic: `if age < 0: raise ValueError("Age cannot be negative!")`  
This gives you control over business logic, not just syntax errors.

### 9. Custom Exceptions
```python
class NegativeAgeError(Exception):
    pass
```
- Inherits from `Exception`
- `pass` means no special behavior — just a new name
- Makes code readable: `except NegativeAgeError` is clearer than `except ValueError`

### 10. Indentation and Syntax Errors Encountered
- Extra spaces before `if` inside `try` block → `IndentationError: unexpected indent`
- `print: ("text")` instead of `print("text")` → `SyntaxError`
- Missing colon after `if len(name) < 3` → `SyntaxError`

---

## Exception Hierarchy

```
BaseException
└── Exception
     ├── ValueError
     ├── TypeError
     ├── ZeroDivisionError
     ├── FileNotFoundError
     ├── IndexError
     └── KeyError
```

All exceptions you'll use in normal scripting inherit from `Exception`.  
Only catch `BaseException` if you explicitly want to intercept `KeyboardInterrupt` (Ctrl+C).

---

## Code Examples

### Basic try/except with raise, else, finally

```python
try:
    age = int(input("Enter your age: "))
    if age < 0:
        raise ValueError("Age cannot be negative!")
    result = 100 / age
except ValueError:
    print("Please enter a number, not text!")
except ZeroDivisionError:
    print("Age cannot be zero!")
else:
    print("Great! Your age is:", age)
finally:
    print("Thanks for using the program!")
```

### Custom exception with input validation loop

```python
class InvalidUserNameError(Exception):
    pass

while True:
    try:
        name = input("Enter your name: ")
        if len(name) < 3:
            raise InvalidUserNameError("name is too short")
    except InvalidUserNameError as e:
        print("Try again -", e)
    else:
        print("Welcome,", name)
        break
    finally:
        print("---")
```

**Why this pattern works:**
- `while True` keeps prompting until valid input
- `break` in the `else` block only runs if no exception was raised
- `finally` runs every iteration — useful for visual separation or cleanup

---

## Classic Mistakes

| Mistake | Problem |
|---------|---------|
| `except: pass` | Silently hides all bugs — the worst pattern |
| `except Exception:` | Catches too much — masks unexpected failures |
| Using exceptions for normal flow when `if/else` would be cleaner | Exceptions are for errors, not control flow |
| Code after `raise` in the same block | It will never run |

---

## Connection to Real-World DevOps

Server-side scripts can't crash. A Python script running on a cron job or inside a Docker container needs to:

- **Catch file errors**: `FileNotFoundError` when reading config files
- **Catch network errors**: `ConnectionError` when hitting an API
- **Log the error and continue**: don't kill the whole process for one bad record
- **Exit with a status code**: `sys.exit(1)` inside an `except` block signals failure to the calling system

```python
import sys

try:
    with open("/etc/app/config.yaml") as f:
        config = f.read()
except FileNotFoundError as e:
    print(f"ERROR: Config file missing — {e}")
    sys.exit(1)
```

This is the difference between a script that survives production and one that pages you at 3am.
