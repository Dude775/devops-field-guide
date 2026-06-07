FROM node:22-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY src ./src

ENV PORT=5000
ENV APP_NAME=express-lab75

CMD ["npm", "start"]
