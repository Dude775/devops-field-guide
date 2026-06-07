# Concept: MongoDB + Flask Integration

A quick-reference for connecting Flask to MongoDB using pymongo.

---

## Setup

```bash
pip install "pymongo[srv]" python-dotenv flask
```

```
# .env
MONGO_URI=mongodb+srv://user:password@cluster.mongodb.net/
```

```
# .gitignore
.env
```

---

## Connection (db.py)

```python
import os
from dotenv import load_dotenv
from pymongo import MongoClient

load_dotenv()

client = MongoClient(os.getenv("MONGO_URI"))
db = client["your_database_name"]
```

Always isolate this in `db.py` — keeps Flask app and database connection decoupled, prevents circular imports.

---

## CRUD Operations

```python
from db import db
from bson import ObjectId

# CREATE
result = db.collection.insert_one({"field": "value"})
doc_id = str(result.inserted_id)

# READ ALL
docs = list(db.collection.find())

# READ ONE
doc = db.collection.find_one({"_id": ObjectId(id_string)})

# UPDATE
db.collection.update_one(
    {"_id": ObjectId(id_string)},
    {"$set": {"field": "new_value"}}
)

# DELETE
db.collection.delete_one({"_id": ObjectId(id_string)})
```

---

## ObjectId Handling

MongoDB generates `_id` as `ObjectId` — not JSON serializable.

```python
# After insert_one — convert immediately
db.collection.insert_one(document)
document["_id"] = str(document["_id"])   # mutates in place — handle right after insert

# Before returning any document from find()
doc["_id"] = str(doc["_id"])
```

**insert_one() side-effect**: it adds `_id` to your dict in place. The document is saved to the DB before you see the error. Failed JSON serialization does NOT roll back the insert.

---

## Flask Route Pattern

```python
from flask import Blueprint, request, jsonify
from db import db
from bson import ObjectId

todos_bp = Blueprint("todos", __name__)

@todos_bp.route("/todos", methods=["GET"])
def get_todos():
    todos = list(db.todos.find())
    for todo in todos:
        todo["_id"] = str(todo["_id"])
    return jsonify(todos), 200

@todos_bp.route("/todos", methods=["POST"])
def create_todo():
    new_task = {"title": request.json["title"], "done": False}
    try:
        db.todos.insert_one(new_task)
        new_task["_id"] = str(new_task["_id"])
        return jsonify(new_task), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@todos_bp.route("/todos/<task_id>", methods=["DELETE"])
def delete_todo(task_id):
    db.todos.delete_one({"_id": ObjectId(task_id)})
    return jsonify({"deleted": task_id}), 200
```

---

## App Factory (app.py)

```python
from flask import Flask
from routes import todos_bp

app = Flask(__name__)
app.register_blueprint(todos_bp)

if __name__ == "__main__":
    app.run(debug=True)
```

---

## Circular Import Rule

```
app.py  →  routes.py  →  db.py
                          ↑ no Flask dependency
```

`db.py` imports nothing from Flask or app.py — it sits at the bottom of the dependency tree. Any module can import from it safely.

---

## MongoDB Atlas Quick Reference

| Concept | Description |
|---------|-------------|
| Cluster | Your server — a Replica Set (3 nodes: 1 primary, 2 secondary) |
| Database | Namespace inside a cluster |
| Collection | Group of documents (schema-less, like a table) |
| Document | JSON-like record (`_id` auto-generated) |
| Network Access | IP whitelist — `0.0.0.0/0` for dev, specific IP for prod |
| Database User | Separate from Atlas account — credentials go in connection string |

Connection string format:
```
mongodb+srv://<username>:<password>@<cluster>.mongodb.net/<database>
```
