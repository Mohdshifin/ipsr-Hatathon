# Use a small, stable nginx image
FROM nginx:alpine

# Set working dir to nginx html folder
WORKDIR /usr/share/nginx/html

# Remove default static files
RUN rm -rf ./*

# Copy website files into nginx html folder
# (Docker will copy everything from repo# Multi-stage build for optimized image size
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application files
COPY . .

# Build the application (if needed)
# RUN npm run build

# Production stage with nginx
FROM nginx:alpine

# Remove default nginx config
RUN rm -rf /etc/nginx/conf.d/*

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built application from builder stage
# Adjust the source path based on your build output directory
COPY --from=builder /app/dist /usr/share/nginx/html
# If you don't have a build step, use:
# COPY --from=builder /app /usr/share/nginx/html

# OpenShift runs containers as non-root, so we need to adjust permissions
RUN chgrp -R 0 /var/cache/nginx /var/run /var/log/nginx /usr/share/nginx/html && \
    chmod -R g+rwX /var/cache/nginx /var/run /var/log/nginx /usr/share/nginx/html

# Use non-root user
RUN addgroup -g 1001 -S nginx && \
    adduser -S -D -H -u 1001 -h /usr/share/nginx/html -s /sbin/nologin -G nginx -g nginx nginx

USER 1001

# Expose port 8080 (OpenShift default)
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"] root; .dockerignore controls exclusions)
COPY . .
localhost
# Ensure permissions are open so OpenShift (arbitrary UID) can read files
# Files -> 644, Dirs -> 755
RUN find . -type f -exec chmod 644 {} \; \
 && find . -type d -exec chmod 755 {} \;

# Expose port 80 (nginx default)
EXPOSE 80

# Simple healthcheck (optional)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -q --spider http://localhost/ || exit 1

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]

