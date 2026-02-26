# Lab 01 - Task 2: The sep Parameter
# sep controls what appears BETWEEN print arguments

# Default separator is a space
print("Hello", "World")              # Hello World

# Custom separators
print("2026", "02", "26", sep="-")   # 2026-02-26
print("usr", "local", "bin", sep="/") # usr/local/bin
print("A", "B", "C", sep="")         # ABC (no separator)
print("one", "two", "three", sep=", ") # one, two, three
