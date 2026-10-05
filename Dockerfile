FROM alpine:latest AS alpine
FROM docker.n8n.io/n8nio/n8n:latest
COPY --from=alpine /sbin/apk /sbin/apk
COPY --from=alpine /usr/lib/libapk.so* /usr/lib/
USER root
RUN apk add --no-cache ffmpeg curl
USER node
