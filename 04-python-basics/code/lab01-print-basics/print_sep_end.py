# Lab 01 - Task 4: Combining sep and end
# Using both parameters together for precise output control

# Date and time on one line with different separators
print("2026", "02", "26", sep="-", end=" | ")
print("10", "30", "00", sep=":")
# Output: 2026-02-26 | 10:30:00

# Building a CSV-style row without newline
print("name", "age", "role", sep=",", end="\n")
print("David", "30", "DevOps", sep=",", end="\n")
# Output:
# name,age,role
# David,30,DevOps
