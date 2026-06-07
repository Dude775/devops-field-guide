# Stage 1: Build
FROM node:22-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY src ./src
COPY tsconfig.json ./

RUN npm run build

# Stage 2: Runtime - distroless
FROM gcr.io/distroless/nodejs22-debian12

WORKDIR /app

COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist

ENV PORT=3000
EXPOSE 3000

CMD ["dist/index.js"]
