FROM node:20.12.2-alpine as builder
WORKDIR /usr/src
COPY . .

ENV HTTPS_PROXY=http://172.17.0.1:7890
ENV HTTP_PROXY=http://172.17.0.1:7890

RUN corepack enable
RUN pnpm install
RUN pnpm run build

FROM node:20.12.2-alpine
WORKDIR /usr/app
COPY --from=builder /usr/src/dist/output ./output
ENV HOST=0.0.0.0 PORT=4444 NODE_ENV=production
EXPOSE $PORT
CMD ["node", "output/server/index.mjs"]
