FROM gliderlabs/alpine:3.1

RUN apk update \
  && apk add build-base git go wget \
  && GOPATH=/go go get github.com/hashicorp/consul \
  && cd /bin \
  && GOPATH=/go go build github.com/hashicorp/consul \
  && rm -rf /go \
  && cd /tmp \
  && wget --no-check-certificate -O ui.zip https://dl.bintray.com/mitchellh/consul/0.4.1_web_ui.zip \
  && unzip ui.zip \
  && mv dist /ui \
  && rm ui.zip \
  && apk del build-base git go wget \
  && rm -rf /var/cache/apk/*

ADD ./config /config

EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 53 53/udp

VOLUME ["/data"]

ENTRYPOINT ["/bin/consul", "agent", "--config-dir=/config"]

CMD []
