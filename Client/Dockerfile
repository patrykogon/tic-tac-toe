# Build stage
FROM node:16 as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install --verbose
COPY . .
RUN npm run build


# Production stage
FROM nginx:stable-alpine
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
