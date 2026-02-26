# Lab 01 - Task 3: The end Parameter
# end controls what appears AFTER the last argument (default: newline)

# Default end is "\n" - each print starts a new line
print("Line 1")
print("Line 2")

# end="" removes the newline - next print continues on same line
print("Loading", end="")
print("...")                          # Loading...

# Custom end strings
print("Step 1", end=" -> ")
print("Step 2", end=" -> ")
print("Done")                         # Step 1 -> Step 2 -> Done
