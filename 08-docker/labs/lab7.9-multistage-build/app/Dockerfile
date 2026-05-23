# Stage 1: Build - image מלא להתקנת תלויות
FROM node:22-alpine AS build

WORKDIR /app

# העתקת קבצי תלויות בלבד - שכבה נפרדת ל-cache
COPY package.json package-lock.json ./

# התקנה דטרמיניסטית, רק production
RUN npm ci --omit=dev

# העתקת קוד המקור
COPY src ./src


# Stage 2: Runtime - distroless, רק מה שצריך להרצה
FROM gcr.io/distroless/nodejs22-debian12

WORKDIR /app

# העתקה מה-stage הראשון לפי השם build
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package.json ./package.json
COPY --from=build /app/src ./src

EXPOSE 3000

# distroless/nodejs כבר מגדיר node כ-ENTRYPOINT
# לכן CMD מקבל רק את הנתיב לסקריפט
CMD ["src/server.js"]
