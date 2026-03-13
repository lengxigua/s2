FROM alpine:latest
RUN apk add --no-cache curl unzip
WORKDIR /app
RUN echo '{ \
  "log": {"loglevel": "warning"}, \
  "inbounds": [{ \
    "port": 3000, \
    "protocol": "socks", \
    "settings": { \
      "auth": "password", \
      "accounts": [{"user": "123456", "pass": "123456"}], \
      "udp": true \
    } \
  }], \
  "outbounds": [{"protocol": "freedom"}] \
}' > config.json

RUN curl -L -o xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
    && unzip xray.zip \
    && chmod +x xray \
    && rm xray.zip

EXPOSE 3000

CMD ["./xray", "-config", "config.json"]
