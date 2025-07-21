# Multi-stage build for production-ready React app
# Stage 1: Dependencies
FROM node:18-alpine AS deps
# Install dependencies for native modules
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies with security audit
RUN npm ci --only=production --legacy-peer-deps && \
    npm audit --audit-level=moderate || true

# Stage 2: Build
FROM node:18-alpine AS builder
WORKDIR /app

# Copy dependencies from deps stage
COPY --from=deps /app/node_modules ./node_modules
COPY package.json package-lock.json ./

# Copy source code
COPY . .

# Set environment variables for build
ENV NODE_ENV=production
ENV GENERATE_SOURCEMAP=false
ENV CI=true

# Build the application
RUN npm run build

# Stage 3: Production runtime
FROM nginx:alpine AS production

# Install security updates (no need to add user)
RUN apk add --no-cache --upgrade

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx-default.conf /etc/nginx/conf.d/default.conf

# Copy built application
COPY --from=builder /app/build /usr/share/nginx/html

# Create necessary directories and set permissions
RUN mkdir -p /var/cache/nginx /var/log/nginx /var/run

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]

# Stage 4: Development (optional)
FROM node:18-alpine AS development
WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install all dependencies including dev dependencies
RUN npm install --legacy-peer-deps

# Copy source code
COPY . .

# Expose development port
EXPOSE 3000

# Start development server
CMD ["npm", "start"] 