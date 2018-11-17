FROM alpine:3.7
RUN apk update \
    && apk add --no-cache py-pip tzdata
RUN pip install shadowsocks
COPY shadowsocks.json /etc/shadowsocks.json
COPY entrypoint.sh /entrypoint
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && chmod +x /entrypoint \
    && apk del tzdata
EXPOSE 8388
ENTRYPOINT ["/entrypoint"]
