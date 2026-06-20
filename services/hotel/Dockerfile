# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Copy package files
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy source code
COPY . .

# Build application
RUN pnpm run build

# Generate Prisma client
RUN pnpm exec prisma generate

# Runtime stage
FROM node:20-alpine

WORKDIR /app

# Install pnpm and dumb-init
RUN npm install -g pnpm && apk add --no-cache dumb-init

# Copy package files
COPY package.json pnpm-lock.yaml ./

# Install only production dependencies
RUN pnpm install --prod --frozen-lockfile

# Copy Prisma files
COPY prisma ./prisma

# Generate Prisma client
RUN pnpm exec prisma generate

# Copy built application from builder
COPY --from=builder /app/dist ./dist

EXPOSE 3000

# Use dumb-init to handle signals properly
ENTRYPOINT ["/usr/sbin/dumb-init", "--"]

CMD ["pnpm", "start:prod"]
