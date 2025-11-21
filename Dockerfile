# -------- BUILD STAGE --------
FROM node:14-alpine AS build

WORKDIR /app

ARG TMDB_V3_API_KEY
ENV REACT_APP_TMDB_KEY=${TMDB_V3_API_KEY}

COPY package.json package-lock.json ./

RUN npm install

COPY . .

RUN npm run build

# -------- PRODUCTION --------
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
