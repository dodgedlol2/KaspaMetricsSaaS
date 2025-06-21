FROM node:20-slim

# Install necessary packages
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install Wasp CLI
RUN curl -sSL https://get.wasp.sh/installer.sh | sh
ENV PATH="/root/.local/bin:$PATH"

# Copy source code
COPY . .

# Build the Wasp app
RUN wasp build

# Move to the built app directory and install production dependencies
WORKDIR /app/.wasp/build
RUN npm install --only=production

# Debug: Check what's in package.json
RUN cat package.json

# Expose port
EXPOSE 3001

# Start the application with explicit shell
CMD ["/bin/bash", "-c", "npm run start"]
