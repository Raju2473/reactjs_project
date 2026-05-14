# ─────────────────────────────────────────────────────────────
# Stage 1 — Builder
# Installs dependencies and builds the Vite React app
# ─────────────────────────────────────────────────────────────
FROM node:20-alpine AS builder
 
WORKDIR /app
 
# Copy package files first (Docker layer cache optimization)
# If package.json didn't change, npm ci is skipped on rebuild
COPY package.json package-lock.json ./
 
RUN npm ci
 
# Copy rest of source code
COPY . .
 
# Build Vite app → outputs to /app/dist
RUN npm run build
 
# ─────────────────────────────────────────────────────────────
# Stage 2 — Production image
# Copies only the built dist/ folder into a lean nginx image
# Final image is ~25MB instead of ~400MB (no node_modules)
# ─────────────────────────────────────────────────────────────
FROM nginx:alpine
 
# Remove default nginx page
RUN rm -rf /usr/share/nginx/html/*
 
# Copy built app from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html
 
# Copy your custom nginx config (handles React Router client-side routing)
COPY nginx.conf /etc/nginx/conf.d/default.conf
 
# Expose port 80
EXPOSE 80
 
# nginx starts automatically — no CMD needed (base image handles it)