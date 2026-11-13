# Gyro Pipeline örneği: statik site, ayrıcalıksız nginx (8080), kök olmayan kullanıcı.
FROM nginxinc/nginx-unprivileged:1.27-alpine
ARG APP_VERSION=dev
LABEL org.opencontainers.image.title="gyro-pipeline-ornek" org.opencontainers.image.version="${APP_VERSION}"
COPY --chown=101:101 site/ /usr/share/nginx/html/
EXPOSE 8080
