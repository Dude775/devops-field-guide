# Postman API Labs - JSONPlaceholder + PokeAPI

**Module**: 03 - Networking  
**Completed**: 2026-04-12  
**Tools**: Postman, Collection Runner, Fern Docs

---

## Summary

| Lab | API | Resources | Methods | Requests | Status |
|-----|-----|-----------|---------|----------|--------|
| Lab 1 | JSONPlaceholder | posts, comments, albums, photos, todos, users | GET, POST, PUT, PATCH, DELETE | 30+ | Done |
| Lab 2 | PokeAPI | pokemon, moves, abilities, types, items, locations, berries, games, contests, encounters, evolution | GET only | 40+ | Done |

---

## Lab 1: JSONPlaceholder API - Rebuilt

### What This Is

JSONPlaceholder is a fake REST API used for testing and prototyping. Nothing persists - every POST/PUT/PATCH returns a fake success response, but no data is actually saved.

### Resources Covered

| Folder | Endpoints | Methods Used |
|--------|-----------|--------------|
| posts | /posts, /posts/:id, /posts/:id/comments | GET, POST, PUT, PATCH, DELETE |
| comments | /comments, /comments/:id | GET, POST, PUT, PATCH, DELETE |
| albums | /albums, /albums/:id, /albums/:id/photos | GET, POST, PUT, PATCH, DELETE |
| photos | /photos, /photos/:id | GET, POST, PUT, PATCH, DELETE |
| todos | /todos, /todos/:id | GET, POST, PUT, PATCH, DELETE |
| users | /users, /users/:id, /users/:id/todos | GET, POST, PUT, PATCH, DELETE |

### HTTP Methods Breakdown

| Method | Purpose | Expected Response | Notes |
|--------|---------|-------------------|-------|
| GET | Read resource | 200 OK | Single item or list |
| POST | Create new resource | 201 Created | Returns new item with generated id |
| PUT | Full replace | 200 OK | Must send all fields |
| PATCH | Partial update | 200 OK | Send only changed fields |
| DELETE | Remove resource | 200 OK | Returns empty object `{}` |

### Key Concepts

- **REST URL structure**: `/resource` (list), `/resource/:id` (single), `/resource/:id/sub-resource` (nested)
- **PUT vs PATCH**: PUT replaces the entire object - if you omit a field, it's gone. PATCH only updates what you send.
- **Query params for filtering**: `GET /posts?userId=1` returns only posts by user 1
- **Pagination**: `?_limit=5&_start=0` controls page size and offset
- **Status codes matter**: 201 on create, 200 on everything else, the API tells you what happened

### Collection Runner Result

- 0 errors, all 200/201
- Screenshot: `screenshots/JSONPlaceholder_Test - Good.jpg`

---

## Lab 2: PokeAPI - Rebuilt Documentation

### What This Is

PokeAPI is a consumption-only API — only GET is available. No authentication, no writes, no persistence. The entire Pokémon universe as structured data, built by the community.

> "This is a consumption-only API — only the HTTP GET method is available on resources."

### Folders Built

| Folder | Endpoints Covered | Notes |
|--------|-------------------|-------|
| _research notes | / (API root) | Entry point, lists all available resources |
| Pokemon | /pokemon, /pokemon/:id, /pokemon/:name, pagination | 1302+ species - always paginate |
| Moves | /move, /move/:id, /move/:name, /move-damage-class | 900+ moves |
| Abilities | /ability, /ability/:id, /ability/:name, /ability-category | |
| Types | /type, /type/:id, /type/:name | 20 types total |
| Items | /item, /item/:id, /item-category, /item-attribute | |
| Locations | /location, /location-area, /pal-park-area | Deeply nested |
| Berry | /berry, /berry-flavor, /berry-firmness | Berry→item link |
| Game | /version, /version-group, /generation | Generation→everything |
| Contests | /contest-type, /contest-effect, /super-contest-effect | contest-type has berry_flavor link |
| Encounters | /encounter-method, /encounter-condition, /encounter-condition-value | |
| Evolution | /evolution-chain/:id, /evolution-trigger | Most complex JSON in the API |

### Key Findings

**Unnamed endpoints**  
Some endpoints only accept a numeric ID — there is no named lookup. Example: `evolution-chain` has no name, only `/evolution-chain/1`. Trying a name will return 404.

**Hypermedia pattern**  
URLs appear inside responses as values, linking to related resources. These are not decoration - they are the API's navigation system.

```json
{
  "url": "https://pokeapi.co/api/v2/pokemon/1/"
}
```

Following these URLs is how you traverse the API graph.

**Pagination everywhere**  
Every list endpoint returns paginated results. Default limit is 20.  
Always use `?limit=20&offset=0` - never pull 1300 records at once.

**Evolution chain complexity**  
`/evolution-chain/:id` returns deeply nested JSON with a `chain` object containing recursive `evolves_to` arrays. The deepest response in the API.

**Resource hierarchy**  
```
generation → version-group → version
location → location-area → pokemon-encounters
berry → berry-flavor → contest-type
```

### Collection Runner Result

- 0 errors, 0 failed
- Screenshot: `screenshots/PokeAPI_Run results - Good.jpg`

### Published Docs

Fern: https://david-rubin-s-team.docs.buildwithfern.com/poke-api-rebuilt-documentation/introduction

---

## Iron Rules Earned

- "Read the docs before touching Postman."
- "URLs inside a response are not decoration - they are the API's navigation."
- "Unnamed endpoints only accept ID, never a name."
- "Pagination exists everywhere - never pull 1300 records at once."
- "POST returns 201. GET returns 200. The code tells you what happened."
- "PUT replaces. PATCH patches. They are not interchangeable."
- "A consumption-only API has no POST, no PUT, no auth - just GET and the data."

---

## Files

| File | Description |
|------|-------------|
| `JSONPlaceholder API - Rebuilt.postman_collection.json` | Postman collection - Lab 1 |
| `PokeAPI - Rebuilt Documentation.postman_collection.json` | Postman collection - Lab 2 |
| `screenshots/JSONPlaceholder_Test - Good.jpg` | Collection runner - Lab 1 |
| `screenshots/PokeAPI_Run results - Good.jpg` | Collection runner - Lab 2 |
