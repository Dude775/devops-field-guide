FROM node:18-alpine
WORKDIR /app
COPY package.json .
COPY app.js .
RUN npm install --omit=dev
EXPOSE 3000
CMD ["node", "app.js"]
