FROM node:14.16.0-alpine

RUN apk add --no-cache --virtual .build-deps alpine-sdk python

WORKDIR /app

COPY package.json yarn.lock .yarnclean prisma ./

RUN yarn install --frozen-lockfile

COPY . .

RUN yarn build


FROM node:14.16.0-alpine

WORKDIR /app

COPY --from=0 /app/package.json /app/yarn.lock /app/.yarnclean /app/schema.prisma /app/.env ./

RUN yarn install --frozen-lockfile --production

COPY --from=0 /app/src ./src/

COPY --from=0 /app/dist ./dist/

EXPOSE 4002

CMD [ "yarn",  "start" ]
