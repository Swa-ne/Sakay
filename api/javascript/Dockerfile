FROM node:23-alpine3.20 as development

WORKDIR /app

COPY package*.json .

RUN npm install

COPY . .

RUN npm run build

FROM node:23-alpine3.20 as production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /app

COPY package*.json .

RUN npm install --production

COPY --from=development /app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/index.js"]