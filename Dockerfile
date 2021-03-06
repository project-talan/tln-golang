FROM golang:1.16-alpine as builder
LABEL maintainer="Vladyslav Kurmaz <vladislav.kurmaz@gmail.com>"

WORKDIR /app
COPY go.mod go.sum service.go ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main service.go


######## Start a new stage from scratch #######
FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /root/
COPY --from=builder /app/main .

EXPOSE 8080

CMD ["./main"]