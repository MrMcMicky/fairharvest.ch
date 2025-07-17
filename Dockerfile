FROM nginx:alpine

# Copy static files
COPY index.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/
COPY logo.png /usr/share/nginx/html/
COPY favicon.png /usr/share/nginx/html/

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 inside container
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]