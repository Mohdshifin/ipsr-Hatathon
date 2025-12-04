FROM nginx:alpine

# Remove default site
RUN rm -rf /usr/share/nginx/html/*

# Copy your static files
COPY . /usr/share/nginx/html

# Fix permissions for OpenShift random UID
RUN chmod -R 777 /usr/share/nginx/html /var/cache/nginx /var/run

# Change nginx to run on 8080 instead of 80
RUN sed -i 's/listen       80;/listen       8080;/' /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
