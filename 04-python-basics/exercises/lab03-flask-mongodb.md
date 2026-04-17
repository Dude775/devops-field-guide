# Lab 03 Summary: Flask + MongoDB Integration

**Class**: Flask Module — Day 3 (16/04/2026)
**Topics**: MongoDB Atlas setup, pymongo driver, connecting Flask to MongoDB, ObjectId handling, .env security

---

## What Was Practiced

- Setting up a free MongoDB Atlas cluster (M0) on AWS eu-central
- Connecting to Atlas via MongoDB Compass (GUI) and pymongo (driver)
- Integrating Flask with MongoDB using the pymongo driver
- Handling ObjectId — the gotcha that bites everyone once
- Securing credentials with python-dotenv and `.env` files
- Solving circular import problems by extracting shared resources

---

## Architecture Evolution

| Day | Structure | Data Storage |
|-----|-----------|-------------|
| Day 1 | Monolith — `todo_app.py` (everything in one file) | In-memory list |
| Day 2 | Blueprints — `app.py` / `routes.py` / `models.py` / `errors.py` | In-memory list |
| Day 3 | Blueprints + Database — adds `db.py` | MongoDB Atlas |

The list of tasks that lived in `models.py` is gone. Data now lives in MongoDB — survives restarts, scales independently, can be queried.

---

## Connection Flow

```
Postman (HTTP request)
    ↓
Flask (routes.py) — validates and processes
    ↓
pymongo (db.py) — translates to MongoDB wire protocol
    ↓
MongoDB Atlas (cloud cluster) — stores documents
    ↓
Response back up the chain
```

---

## Q&A from the Session

### 1. What is MongoDB Atlas?

A managed cloud database service — MongoDB hosted by MongoDB Inc. You create a cluster, they manage the infrastructure. The free M0 tier (512MB, shared CPU) is enough for development and small projects.

Key Atlas concepts:
- **Cluster**: your database server — a Replica Set of 3 nodes by default (one primary, two secondary for redundancy)
- **Database**: a namespace inside the cluster (like `production`, `staging`, `sample_mflix`)
- **Collection**: a group of documents (like a table, but schema-less)
- **Network Access**: IP whitelist — `0.0.0.0/0` = allow all (dev only), specific IP = production
- **Database Users**: separate from your Atlas account login — these credentials go in your connection string

### 2. What is pymongo?

The official Python driver for MongoDB. It speaks the MongoDB wire protocol and gives you Python methods to run database operations.

```bash
pip install "pymongo[srv]"
```

> Note: pymongo 4.16+ no longer requires `[srv]` extra — the warning appears but it still works.

### 3. How does the connection work?

```python
from pymongo import MongoClient

client = MongoClient("mongodb+srv://user:password@cluster.mongodb.net/")
db = client["production"]          # selects (or creates) a database
collection = db["todos"]           # selects (or creates) a collection
```

Nothing is created until you write data. MongoDB creates databases and collections lazily — on first insert.

### 4. What is ObjectId and why does it break JSON?

MongoDB auto-generates a unique `_id` field for every document. It looks like this:

```
ObjectId('6619a3f2c4f1234abc567def')
```

It is **not a string**. It is a BSON type — 12 bytes encoding timestamp, machine ID, and a counter. Flask's `jsonify()` doesn't know how to serialize it, so it throws a `TypeError`.

**The fix:**

```python
new_task["_id"] = str(new_task["_id"])  # convert BEFORE jsonify
return jsonify(new_task), 201
```

### 5. The insert_one() side-effect gotcha

This is the lesson that sticks:

```python
new_task = {"title": "Buy milk", "done": False}

# insert_one MUTATES new_task in memory
db.todos.insert_one(new_task)

# new_task is now:
# {"title": "Buy milk", "done": False, "_id": ObjectId("...")}
```

`insert_one()` modifies your original dict — it adds `_id` to it **in place**. The document is already saved to MongoDB when this happens.

**The silent danger:**

```python
new_task = {"title": "Buy milk", "done": False}
db.todos.insert_one(new_task)
return jsonify(new_task), 201  # ← TypeError: ObjectId not serializable
```

You see the error. You try again. You try again. Each attempt succeeds in the DB — only the response fails. Result: **multiple duplicate documents** in MongoDB.

**The correct pattern:**

```python
new_task = {"title": request.json["title"], "done": False}
db.todos.insert_one(new_task)
new_task["_id"] = str(new_task["_id"])   # ← handle _id immediately after insert
return jsonify(new_task), 201
```

Handle `_id` conversion **immediately after** `insert_one()`, before anything else.

### 6. The .env security pattern

Credentials in your source code = credentials in git history. Once pushed, they're there forever — even if you delete the line later.

**The pattern:**

```
# .env (in .gitignore — never committed)
MONGO_URI=mongodb+srv://user:password@cluster.mongodb.net/
```

```python
# db.py
import os
from dotenv import load_dotenv
from pymongo import MongoClient

load_dotenv()

client = MongoClient(os.getenv("MONGO_URI"))
db = client["production"]
```

```
# .gitignore
.env
```

Always create `.env.example` with placeholder values so teammates know what variables are needed:

```
# .env.example (committed — safe, no real values)
MONGO_URI=mongodb+srv://username:password@cluster.mongodb.net/
```

### 7. The circular import problem and why db.py solves it

**The problem:**

```python
# app.py
from routes import todos_bp   # routes.py needs something from app.py

# routes.py
from app import app           # ← circular: app imports routes, routes imports app
```

Python starts loading `app.py`, hits the `routes` import, starts loading `routes.py`, hits the `app` import — but `app.py` isn't finished loading yet. Crash.

**The solution: extract shared resources to their own module**

```python
# db.py — no Flask dependency, no circular risk
from pymongo import MongoClient
import os
from dotenv import load_dotenv

load_dotenv()
client = MongoClient(os.getenv("MONGO_URI"))
db = client["production"]
```

```python
# routes.py
from db import db             # ✓ db.py doesn't import from app.py
```

```python
# app.py
from routes import todos_bp   # ✓ routes.py doesn't import from app.py
```

The dependency graph becomes a tree — no cycles.

### 8. Bugs caught in class

- Instructor used `errorhandler` (decorator on the function) instead of `app_errorhandler` (method on the Blueprint) — works differently, caught during live demo
- `insert_one()` side-effect caused duplicate documents when jsonify failed multiple times

---

## File Structure (Day 3)

```
flask-module/
├── app.py          # Flask app factory, Blueprint registration
├── db.py           # MongoClient + db variable (isolated)
├── routes.py       # Blueprint: /todos GET, POST, DELETE
├── models.py       # (no longer stores data — may hold schemas/validation)
├── errors.py       # Error handlers for 404, 500, etc.
├── .env            # MONGO_URI (gitignored)
├── .env.example    # Placeholder for teammates
└── requirements.txt
```

---

## pymongo CRUD Reference

```python
from db import db

# INSERT
result = db.todos.insert_one({"title": "Task", "done": False})
# result.inserted_id → ObjectId

# FIND ALL
documents = list(db.todos.find())
# Note: find() returns a Cursor — wrap in list() to iterate multiple times

# FIND ONE
doc = db.todos.find_one({"_id": ObjectId("6619a3f2...")})

# UPDATE
db.todos.update_one(
    {"_id": ObjectId(task_id)},
    {"$set": {"done": True}}
)

# DELETE
db.todos.delete_one({"_id": ObjectId(task_id)})
```

**ObjectId in routes** — incoming IDs from URLs are strings, MongoDB expects ObjectId:

```python
from bson import ObjectId

@todos_bp.route("/todos/<task_id>", methods=["DELETE"])
def delete_task(task_id):
    db.todos.delete_one({"_id": ObjectId(task_id)})
    return jsonify({"deleted": task_id}), 200
```

---

## Classic Mistakes

| Mistake | Problem |
|---------|---------|
| `jsonify(doc)` with `_id` as ObjectId | `TypeError: Object of type ObjectId is not JSON serializable` |
| Retrying a failed POST without checking the DB | Creates duplicate documents — the insert succeeded, only the response failed |
| `MONGO_URI` hardcoded in `app.py` | Credentials exposed in git history forever |
| `from app import app` inside `routes.py` | Circular import — Python can't resolve the dependency cycle |
| `list(db.todos.find())` with ObjectId fields | Same serialization error — convert all `_id` fields before returning |

---

## Connection to Real-World DevOps

This pattern — Flask + MongoDB + .env + separate db module — is production architecture in miniature.

**Why it matters for DevOps:**

- **Environment variables**: the same `.env` pattern scales to Kubernetes Secrets and AWS Parameter Store. You never hardcode. Ever.
- **Replica Set**: Atlas M0 runs 3 nodes. Production clusters run 3–7+ nodes. Understanding this is why `find()` reads can be eventually consistent.
- **Circular imports = dependency management**: In large services, circular dependencies cause boot failures. The `db.py` extraction is the same principle as dependency injection in frameworks — keep shared resources at the bottom of the dependency tree.
- **ObjectId is a data contract**: when you expose an API, the ID format matters. Switching from UUID strings to ObjectId strings is a breaking change for clients. Choose early.

```python
# The pattern that survives production
try:
    result = db.todos.insert_one(new_task)
    new_task["_id"] = str(new_task["_id"])
    return jsonify(new_task), 201
except Exception as e:
    # Lab 02 payoff: error handling wraps every DB operation in production
    return jsonify({"error": str(e)}), 500
```

Lab 02's error handling is not optional when touching a database. Networks fail, clusters restart, connection pools exhaust. Wrap every DB call.

---

## Iron Rules Earned

- **"insert_one() mutates your dict — handle `_id` before responding."**
- **"Credentials in code = credentials in git. Use .env from day one."**
- **"Circular imports? Extract shared resources to their own module."**

---

## Live Project

The running Flask todo app lives at: [github.com/Dude775/flask-module](https://github.com/Dude775/flask-module)
