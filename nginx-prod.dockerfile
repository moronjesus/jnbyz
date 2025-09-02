FROM node:12-alpine as dev

WORKDIR /app

# Copy configuration files
COPY package*.json ./

RUN npm ci

COPY .env* /app
COPY . /app

# Build application (produces dist/ folder)
RUN npm run build

FROM nginx:stable-alpine as web

WORKDIR /usr/share/nginx/html

COPY --from=dev /app/dist/ /usr/share/nginx/html
RUN chown nginx:nginx -R /usr/share/nginx/html
