# -------- BUILD STAGE --------
FROM node:18-alpine AS build
WORKDIR /app

ARG TMDB_V3_API_KEY
ENV REACT_APP_TMDB_KEY=${TMDB_V3_API_KEY}

COPY package.json ./

# Remove broken lock file (optional)
RUN rm -f package-lock.json

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy rest of project
COPY . .

# Build static files
RUN npm run build


# -------- PRODUCTION STAGE --------
FROM nginx:stable-alpine

# Copy build output from previous stage
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
