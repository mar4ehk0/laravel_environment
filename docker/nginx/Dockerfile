FROM nginx:1.23.1-alpine

ARG APP_DOMAIN
ARG PUBLIC_PATH
ARG SRC_PATH

COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN sed -i -r "s|%PUBLIC_PATH%|$PUBLIC_PATH|g" /etc/nginx/conf.d/default.conf
RUN sed -i -r "s|%APP_DOMAIN%|$APP_DOMAIN|g" /etc/nginx/conf.d/default.conf

WORKDIR $SRC_PATH