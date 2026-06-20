const http = require('http');
const PORT = process.env.PORT || 3000;

const html = `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>🚀 ECR Demo - 3D Powered</title>
  <script type="module" src="https://unpkg.com/@splinetool/viewer@1.9.48/build/spline-viewer.js"></script>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: 'Segoe UI', system-ui, sans-serif;
      min-height: 100vh;
      background: #000;
      color: white;
      overflow: hidden;
      position: relative;
    }
    .spline-container {
      position: absolute;
      top: 0; left: 0;
      width: 100%;
      height: 100vh;
      z-index: 1;
    }
    spline-viewer {
      width: 100%;
      height: 100%;
    }
    .overlay {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      z-index: 10;
      text-align: center;
      pointer-events: none;
      animation: fadeIn 2s ease-out;
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translate(-50%, -40%); }
      to   { opacity: 1; transform: translate(-50%, -50%); }
    }
    h1 {
      font-size: 4em;
      font-weight: 900;
      background: linear-gradient(90deg, #00f5ff, #ff00ff, #ffff00);
      background-size: 200% 200%;
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      animation: gradient 3s ease infinite;
      text-shadow: 0 0 40px rgba(0, 245, 255, 0.5);
      margin-bottom: 20px;
    }
    @keyframes gradient {
      0%, 100% { background-position: 0% 50%; }
      50%      { background-position: 100% 50%; }
    }
    .subtitle {
      font-size: 1.3em;
      opacity: 0.9;
      margin-bottom: 30px;
      text-shadow: 2px 2px 10px black;
    }
    .badges {
      display: flex;
      gap: 12px;
      justify-content: center;
      flex-wrap: wrap;
      pointer-events: auto;
    }
    .badge {
      background: rgba(255, 255, 255, 0.1);
      backdrop-filter: blur(10px);
      padding: 10px 20px;
      border-radius: 30px;
      border: 1px solid rgba(255, 255, 255, 0.2);
      font-weight: bold;
      transition: all 0.3s;
      cursor: pointer;
    }
    .badge:hover {
      transform: scale(1.1);
      background: rgba(255, 255, 255, 0.2);
      box-shadow: 0 0 20px rgba(0, 245, 255, 0.5);
    }
    .footer {
      position: absolute;
      bottom: 20px;
      width: 100%;
      text-align: center;
      z-index: 10;
      opacity: 0.6;
      font-size: 0.9em;
    }
  </style>
</head>
<body>
  <div class="spline-container">
    <spline-viewer url="https://prod.spline.design/kZDDjO5HuC9GJUM2/scene.splinecode"></spline-viewer>
  </div>
  
  <div class="overlay">
    <h1>🚀 ECR Powered</h1>
    <p class="subtitle">Deployed via Docker · Pulled from AWS ECR · Running on EC2</p>
    <div class="badges">
      <div class="badge">🐳 Docker</div>
      <div class="badge">☁️ AWS ECR</div>
      <div class="badge">🖥️ EC2</div>
      <div class="badge">⚡ Node.js</div>
    </div>
  </div>
  
  <div class="footer">
    Class-Lab 1.1 · David · Powered by Spline 3D
  </div>
</body>
</html>
`;

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
  res.end(html);
});

server.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});
