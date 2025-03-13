# 1️⃣ Use a lightweight Node.js image
FROM node:18-slim AS builder

WORKDIR /app

# 2️⃣ Copy package files first for caching
COPY package.json package-lock.json ./

# 3️⃣ Install dependencies
RUN npm ci

# 4️⃣ Copy the rest of the app files
COPY . .

# 5️⃣ Build the Next.js app
RUN npm run build

# 6️⃣ Start production container
FROM node:18-slim

WORKDIR /app

# Copy only necessary files
COPY --from=builder /app/.next .next
COPY --from=builder /app/node_modules node_modules
COPY --from=builder /app/package.json package.json
COPY --from=builder /app/public public

# Expose the port
EXPOSE 3000

CMD ["npm", "start"]

