
FROM node:16-alpine AS build
WORKDIR /app

ARG TMDB_V3_API_KEY
ENV REACT_APP_TMDB_KEY=${TMDB_V3_API_KEY}

COPY package.json ./

# Remove the lock file because it is broken
RUN rm -f package-lock.json

# Install dependencies fresh
RUN npm install --legacy-peer-deps

COPY . .

RUN npm run build

FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

