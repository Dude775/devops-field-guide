const express = require("express");
const os = require("os");

const port = 80;
const app = express();
const color = "blue";
const hostname = os.hostname();

app.get("/", (req, res) => {
  res.send(
    `<h1 style="color:${color};">Hello from Color API</h1>
    <h2>Host hostname: ${hostname}</h2>`,
  );
});

app.get("/api", (req, res) => {
  const { format } = req.query;
  if (format === "json") {
    return res.json({
      color,
      hostname,
    });
  } else {
    return res.send(`color=${color} hostname=${hostname}`);
  }
});

app.listen(port, () => {
  console.log(`Color API listening on port: ${port}`);
});
