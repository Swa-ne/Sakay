FROM node:24-alpine3.21 AS builder
WORKDIR /app

COPY package*.json .
RUN npm install
COPY . .
RUN npm run build

FROM node:24-alpine3.21

ENV NODE_ENV=production
WORKDIR /app
COPY package*.json .
RUN npm install --production
COPY --from=builder /app/dist ./dist

EXPOSE 3000
CMD ["node", "dist/src/index.js"]