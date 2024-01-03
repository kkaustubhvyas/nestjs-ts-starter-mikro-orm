FROM ubuntu:20.04 AS build

RUN apt-get update 

RUN apt-get install -y \
  python3 \
  curl  \
  build-essential \
  make

RUN apt-get update
RUN apt-get install -y ca-certificates curl gnupg
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

ENV NODE_MAJOR=20
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

RUN apt-get update
RUN apt-get install nodejs -y

WORKDIR /code

COPY . .

ARG BUILD_TAG
ENV BUILD_TAG=$BUILD_TAG

RUN npm clean-install

RUN npm run build

FROM node:20-alpine AS runtime

RUN apk add curl

WORKDIR /code

COPY --from=build /code /code

CMD npm run start:prod

ENV PORT 3000

EXPOSE ${PORT}
