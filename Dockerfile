ARG GOVERSION=1.22

FROM golang:${GOVERSION}-alpine as builder

WORKDIR /build

RUN apk add --no-cache make git bash

ADD go.mod .
ADD go.sum .
ADD Makefile .
RUN make dep

ADD . .
RUN make build

FROM alpine:3.19

COPY --from=builder /build/keepalived-exporter /bin/keepalived-exporter

ENTRYPOINT [ "/bin/keepalived-exporter" ]
