FROM nginx:1.17.9-alpine AS builder

# nginx:alpine contains NGINX_VERSION environment variable, like so:
ENV NGINX_VERSION 1.17.9

ENV HMAC_VERSION 0.3

# Download sources
RUN wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz && \
    wget "https://github.com/nginx-modules/ngx_http_hmac_secure_link_module/archive/${HMAC_VERSION}.tar.gz" -O hmac-secure.tar.gz

# For latest build deps, see https://github.com/nginxinc/docker-nginx/blob/master/mainline/alpine/Dockerfile
RUN apk add --no-cache --virtual .build-deps \
  gcc \
  libc-dev \
  make \
  openssl-dev \
  pcre-dev \
  zlib-dev \
  linux-headers \
  curl \
  gnupg \
  libxslt-dev \
  gd-dev \
  geoip-dev

# Reuse same cli arguments as the nginx:alpine image used to build
RUN CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') \
    CONFARGS=${CONFARGS/-Os -fomit-frame-pointer/-Os} && \
    mkdir /usr/src && \
	tar -zxC /usr/src -f nginx.tar.gz && \
    tar -xzvf "hmac-secure.tar.gz" && \
    HMACSECUREDIR="$(pwd)/ngx_http_hmac_secure_link_module-${HMAC_VERSION}" && \
    cd /usr/src/nginx-$NGINX_VERSION && \
    ./configure --with-compat $CONFARGS --add-dynamic-module=$HMACSECUREDIR && \
    make modules && \
    mv ./objs/*.so /


FROM nginx:alpine
# Extract the dynamic module HMAC from the builder image
COPY --from=builder /ngx_http_hmac_secure_link_module.so /usr/local/nginx/modules/ngx_http_hmac_secure_link_module.so
RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
