FROM nginx:latest

LABEL author="Pawel Miroslawski <pmiroslawski@gmail.com>"
LABEL version="1.0"

RUN apt-get update && apt-get install -y vim

# copy custom nginx.conf
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
ADD nginx.conf /etc/nginx/

# prepare conf.d/default config
RUN rm /etc/nginx/conf.d/default.conf
ADD vhost/default.conf /etc/nginx/conf.d/default.conf

RUN mkdir /etc/nginx/sites-available
RUN mkdir /etc/nginx/sites-enabled

ADD vhost/app.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/app.conf /etc/nginx/sites-enabled/app.conf

RUN echo "upstream php-upstream { server php:9000; }" > /etc/nginx/conf.d/upstream.conf

RUN usermod -u 1000 nginx
RUN groupmod -g 1000 nginx

EXPOSE 80
EXPOSE 443
