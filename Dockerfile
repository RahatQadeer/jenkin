# Use lightweight Nginx image
FROM nginx:alpine

# Copy your HTML file into Nginx web root
COPY index.html /usr/share/nginx/html/

# Expose port 80
EXPOSE 80
