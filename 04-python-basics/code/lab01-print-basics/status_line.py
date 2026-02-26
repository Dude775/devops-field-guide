# Lab 01 - Task 5: Status Line
# Practical application - building formatted output like a deployment status

# Simulating a deploy status output
print("=== Deployment Status ===")
print("Service", "Version", "Environment", sep=" | ")
print("-------", "-------", "-----------", sep=" | ")
print("api", "v2.1.0", "production", sep="    | ")
print("web", "v3.0.1", "production", sep="    | ")
print()

# Progress-style output using end
print("Deploying", end="")
print(".", end="")
print(".", end="")
print(".", end=" ")
print("Done!")
# Output: Deploying... Done!
