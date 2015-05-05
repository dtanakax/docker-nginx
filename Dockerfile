# Set the base image
FROM dtanakax/debianjp:wheezy

# File Author / Maintainer
MAINTAINER Daisuke Tanaka, dtanakax@gmail.com

ENV DEBIAN_FRONTEND noninteractive
ENV NGINX_VERSION 1.8.0

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates wget

RUN wget http://nginx.org/keys/nginx_signing.key -O- | apt-key add - && \
    echo "deb http://nginx.org/packages/debian/ wheezy nginx" >> /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y ca-certificates nginx && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get clean all

# Adding the configuration file of the nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Adding the default file
RUN mkdir -p /var/www/html
RUN chown -R nginx:nginx /var/www/

ADD start.sh /start.sh
RUN chmod +x /start.sh

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Define mountable directories.
VOLUME ["/var/www/html", "/etc/nginx", "/var/cache/nginx"]

ENTRYPOINT ["./start.sh"]

# Set the port to 80
EXPOSE 80 443

# Executing sh
CMD ["/usr/sbin/nginx"]