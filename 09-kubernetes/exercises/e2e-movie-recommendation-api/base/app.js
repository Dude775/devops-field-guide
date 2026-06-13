const express = require('express');
const app = express();
const PORT = 3000;

const movies = [
  { title: 'Dune: Part Two', genre: 'Sci-Fi', year: 2024 },
  { title: 'Oppenheimer', genre: 'Biography', year: 2023 },
  { title: 'Top Gun: Maverick', genre: 'Action', year: 2022 },
  { title: 'Everything Everywhere All at Once', genre: 'Sci-Fi', year: 2022 },
  { title: 'Spider-Man: Across the Spider-Verse', genre: 'Animation', year: 2023 },
  { title: 'The Batman', genre: 'Action', year: 2022 },
  { title: 'Knives Out', genre: 'Mystery', year: 2019 },
  { title: 'Parasite', genre: 'Thriller', year: 2019 },
];

app.get('/', (req, res) => {
  const movie = movies[Math.floor(Math.random() * movies.length)];

  res.json({
    version: 'v2',
    message: 'new movie recommendation format',
    data: {
      recommendation: movie,
    },
  });
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', version: 'v2' });
});

app.listen(PORT, () => {
  console.log(`Movie Recommendation API v2 running on port ${PORT}`);
});
