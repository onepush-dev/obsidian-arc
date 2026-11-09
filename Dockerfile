# Obsidian Arc on Railway: the official image (ghcr.io/onyxaxisowo/obsidianarc:v0.12.1, MIT),
# binary unmodified. Changes:
#   - runs as root (uid 0): the image is distroless (no shell to chown) and Railway mounts the
#     /data volume root-owned, so the nonroot user could not write the SQLite database;
#   - baked defaults for Railway's HTTPS edge: trust forwarded headers only from Railway's proxy
#     range, Secure cookies, admin user "admin".
# OBSIDIAN_ADMIN_PASSWORD and OBSIDIAN_SECRET_KEY are generated per deploy by the template, so the
# administrator exists before the first visitor arrives (no first-registrant-becomes-admin race).
FROM ghcr.io/onyxaxisowo/obsidianarc:v0.12.1@sha256:18fb15622025f913becd466afe3f866307f33dde9bb7c770005359701be8e316
USER 0:0
ENV OBSIDIAN_ADDR=:8080 \
    OBSIDIAN_DATA_DIR=/data \
    OBSIDIAN_TRUST_PROXY=true \
    OBSIDIAN_TRUSTED_PROXIES=100.64.0.0/10,127.0.0.1/32 \
    OBSIDIAN_TRUST_CLOUDFLARE=false \
    OBSIDIAN_COOKIE_SECURE=true \
    OBSIDIAN_ADMIN_USER=admin \
    TZ=UTC
EXPOSE 8080
