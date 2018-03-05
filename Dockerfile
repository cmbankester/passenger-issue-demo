FROM alpine:latest

RUN mkdir -p /var/src && cd /var/src
RUN apk add --no-cache ruby ruby-dev ruby-json ruby-bigdecimal tzdata \
  zlib-dev build-base sqlite sqlite-dev curl curl-dev libressl-dev \
  linux-headers procps nodejs yarn pcre-dev \
  && gem install rails passenger --no-document \
  && passenger-config install-standalone-runtime --engine nginx --auto \
  && passenger-config build-native-support

RUN cd /var/src && rails new passenger-test --skip-puma --webpack
RUN cd /var/src/passenger-test && yarn add webpack-cli -D

# See: https://github.com/rails/webpacker/issues/1303
RUN cd /var/src/passenger-test && yarn upgrade webpack-dev-server@^2.11.1 -D

# Turn off gzipping of assets by the webpack dev server
RUN sed -i 's/compress: true/compress: false/' /var/src/passenger-test/config/webpacker.yml

WORKDIR /var/src/passenger-test

CMD ./bin/webpack-dev-server & passenger start -a 0.0.0.0 -p 3000