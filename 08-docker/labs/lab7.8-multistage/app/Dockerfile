FROM node:22-alpine

WORKDIR /app

# קבצי הגדרות תחילה - לניצול cache
COPY package*.json ./

RUN npm ci --omit=dev

# שאר הקוד
COPY src/ ./src/

EXPOSE 3000

CMD ["node", "src/server.js"]
