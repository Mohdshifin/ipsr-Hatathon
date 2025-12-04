FROM nginx:alpine

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy your website files into nginx
COPY . /usr/share/nginx/html

# Expose port
EXPOSE 8080

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
