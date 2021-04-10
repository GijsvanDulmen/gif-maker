FROM golang:alpine AS builder

RUN apk update && apk add --no-cache git

ENV GO111MODULE=on

WORKDIR /usr/src/app

COPY . .

RUN go get -d -v

RUN GOOS=linux CGO_ENABLED=0 GOARCH=amd64 go build -ldflags="-w -s" -o /usr/src/app/app

RUN mkdir /new_tmp && chmod 777 /new_tmp

# Second-stage using an image without anything! :-)
FROM scratch

COPY --from=builder /new_tmp /tmp
COPY --from=builder /usr/src/app/app /usr/src/app/app

ENTRYPOINT ["/usr/src/app/app"]