FROM golang:1 as builder
WORKDIR /go/src/app
COPY . .
RUN CI=1 go test && \
    CGO_ENABLED=0 go build -ldflags '-extldflags "-static"' -o stackdriver_exporter

FROM scratch
COPY --from=builder /go/src/app/stackdriver_exporter /
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
USER 1000:1000
EXPOSE 9255
ENTRYPOINT ["/stackdriver_exporter"]
