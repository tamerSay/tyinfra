FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive 

RUN    echo "deb-src http://archive.ubuntu.com/ubuntu focal main" >> /etc/apt/sources.list
RUN    sed -i 's/main$/main universe/' /etc/apt/sources.list 
RUN    apt-get update
RUN    apt-get -y upgrade
RUN    apt-get -y install wget vim git libpq-dev htop libpcre3-dev libssl-dev perl make build-essential curl ca-certificates

RUN    apt-get -y build-dep nginx
RUN    wget https://openresty.org/download/openresty-1.19.9.1.tar.gz
RUN    tar xvfz openresty-1.19.9.1.tar.gz
RUN    cd openresty-1.19.9.1 ; ./configure --with-luajit  --with-http_addition_module --with-http_dav_module --with-http_geoip_module --with-http_gzip_static_module --with-http_image_filter_module --with-http_realip_module --with-http_stub_status_module --with-http_ssl_module --with-http_sub_module --with-http_xslt_module --with-ipv6 --with-http_postgres_module --with-pcre-jit;  make ; make install

RUN mkdir -p /var/log/nginx && mkdir -p /var/run/openresty && ln -sf /dev/stdout /var/log/nginx/access.log  && ln -sf /dev/stderr /var/log/nginx/error.log
RUN mkdir -p /etc/nginx/sites-ssl/
ENV PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

COPY tyinfra.conf /etc/nginx/conf.d/tyinfra.conf
COPY sites-ssl/tyinfra-key.pem /etc/nginx/sites-ssl/tyinfra-key.pem
COPY sites-ssl/tyinfra-cert.pem /etc/nginx/sites-ssl/tyinfra-cert.pem

#RUN    chown www-data:www-data /usr/local/openresty/nginx/conf/nginx.conf

EXPOSE 80 443
CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
