FROM golang:1.8-alpine AS builder

MAINTAINER Jose Maria Hidalgo Garcia <jhidalgo3@gmail.com>

RUN apk add --no-cache --update ca-certificates \
    && apk add curl git coreutils \
    && rm /var/cache/apk/*

ENV SRC_DIR=/go/src/github.com/jhidalgo3/training-docker-microservice

ADD . /go


WORKDIR ${SRC_DIR}
RUN go get github.com/Masterminds/glide

RUN glide install

RUN CGO_ENABLED=0 GOOS=linux go build -i -v -ldflags "-X github.com/jhidalgo3/training-docker-microservice/config.Commit=$(git describe --always --long)"

FROM alpine:latest  
RUN apk --no-cache add ca-certificates

WORKDIR /root/

COPY --from=builder /go/src/github.com/jhidalgo3/training-docker-microservice/training-docker-microservice  .
ADD ./src/github.com/jhidalgo3/training-docker-microservice/static/ /root/static

CMD ./training-docker-microservice