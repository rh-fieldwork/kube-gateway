# build stage
FROM registry.access.redhat.com/ubi8/go-toolset:latest AS build

WORKDIR /app
COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o /app/ /app/cmd/kube-gateway/... 

# deploy stage
FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

WORKDIR /app
RUN mkdir -p /app/web/public/

COPY --from=build /app/kube-gateway /app/

COPY ./web/public/default.css /app/web/public/
COPY ./web/public/network-side.png /data/web/public/
COPY ./web/public/login.html /app/web/public/index.html
