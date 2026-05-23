FROM nginx:1.27.0
RUN apt-get update && apt-get install -y nano
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 8080
