const express = require('express');
const app = express();
app.use(express.json());

let users = [];

app.get('/users', (req, res) => {
  res.json(users);
});

app.post('/users', (req, res) => {
  users.push(req.body);
  res.status(201).json(req.body);
});

app.listen(3000, () => console.log('listening on 3000'));
