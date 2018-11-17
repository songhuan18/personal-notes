FROM alpine:3.7
RUN apk update \
    && apk add --no-cache py-pip tzdata
RUN pip install shadowsocks
COPY polipo /usr/local/bin/polipo
RUN mkdir -p /usr/share/polipo/www /var/cache/polipo /etc/polipo
COPY shadowsocks.json /etc/shadowsocks.json
COPY config /etc/polipo/config
COPY entrypoint.sh /entrypoint
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apk del tzdata \
    && chmod +x /entrypoint
EXPOSE 8123 1080
ENTRYPOINT ["/entrypoint"]
