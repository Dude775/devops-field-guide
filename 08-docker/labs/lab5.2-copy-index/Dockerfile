FROM nginx:1.27.0
RUN apt-get update && apt-get install -y nano
COPY index.html /usr/share/nginx/html/index.html
RUN chown nginx:nginx /usr/share/nginx/html/index.html
