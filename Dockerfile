# Step 1 - Use Node 18 as base image
FROM node:18-alpine

# Step 2 - Set working directory
WORKDIR /app

# Step 3 - Copy package files
COPY package*.json ./

# Step 4 - Install dependencies
RUN npm install

# Step 5 - Copy source code
COPY . .

# Step 6 - Expose React port
EXPOSE 3000

# Step 7 - Start React with legacy OpenSSL fix
ENV NODE_OPTIONS=--openssl-legacy-provider
CMD ["npm", "start"]
