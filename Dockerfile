FROM alpine:latest

RUN apk add --no-cache curl unzip

WORKDIR /app

RUN curl -L -o xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
    && unzip xray.zip \
    && chmod +x xray \
    && rm -rf xray.zip geoip.dat geosite.dat
    
RUN echo 'printf "{\n\
  \"log\": {\"loglevel\": \"warning\"},\n\
  \"inbounds\": [{\n\
    \"port\": 3000,\n\
    \"protocol\": \"socks\",\n\
    \"settings\": {\n\
      \"auth\": \"password\",\n\
      \"accounts\": [{\"user\": \"${U:-123456}\", \"pass\": \"${P:-123456}\"}],\n\
      \"udp\": true\n\
    }\n\
  }],\n\
  \"outbounds\": [{\"protocol\": \"freedom\"}]\n\
}" > config.json && ./xray -config config.json' > start.sh

RUN chmod +x start.sh

EXPOSE 3000

CMD ["/bin/sh", "start.sh"]
