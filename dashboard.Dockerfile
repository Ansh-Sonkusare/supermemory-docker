FROM node:22-alpine AS builder
RUN apk add --no-cache git
RUN git clone --depth 1 https://github.com/Ansh-Sonkusare/supermemory-dashboard /dashboard
WORKDIR /dashboard
RUN npm install && npm run build

FROM nginx:alpine
COPY --from=builder /dashboard/dist /usr/share/nginx/html
COPY dashboard.nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 5173