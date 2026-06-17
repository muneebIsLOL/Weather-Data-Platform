# Use a lightweight Node.js image for development
FROM node:24.12.0-alpine AS dev

# Set the working directory inside the container
WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json* ./
RUN npm ci

# Copy the rest of the application code and build
COPY . .
RUN npm run build

CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]