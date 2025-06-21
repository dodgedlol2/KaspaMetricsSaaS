FROM node:20-alpine

# Install necessary packages
RUN apk add --no-cache python3 make g++

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install Wasp CLI
RUN curl -sSL https://get.wasp-lang.dev/installer.sh | sh
ENV PATH="/root/.local/bin:$PATH"

# Copy source code
COPY . .

# Build the Wasp app
RUN wasp build

# Install dependencies for the built app
WORKDIR /app/.wasp/build
RUN npm install --only=production

# Expose port
EXPOSE 3001

# Start the application
CMD ["npm", "run", "start"]
