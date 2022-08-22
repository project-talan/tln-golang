FROM golang:1.18.4-alpine as builder
LABEL maintainer="Vladyslav Kurmaz <vladislav.kurmaz@gmail.com>"

WORKDIR /app
COPY go.mod go.sum service.go ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main service.go


FROM alpine:3.16.2

RUN apk --no-cache add ca-certificates

WORKDIR /root/
COPY --from=builder /app/main .

CMD ["./main"]