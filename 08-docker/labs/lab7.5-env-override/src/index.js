const express = require('express');
const app = express();

const PORT = process.env.PORT;
const APP_NAME = process.env.APP_NAME;
console.log(`this is the App Name: ${APP_NAME}`);

app.get('/', (req, res) => {
  res.send(`Hello from ${APP_NAME}! running on port ${PORT}`);
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`App Name: ${APP_NAME}`);
});

