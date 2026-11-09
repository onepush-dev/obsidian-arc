# Obsidian Arc on Railway: the official v0.12.1 binary (ghcr.io/onyxaxisowo/obsidianarc:v0.12.1,
# MIT), unmodified, copied onto Alpine so a small start script can run next to it:
#   - runs as root: Railway mounts the /data volume root-owned (upstream's distroless image runs
#     as nonroot and has no shell to fix that);
#   - baked defaults for Railway's HTTPS edge: trust forwarded headers only from Railway's proxy
#     range, Secure cookies, admin user "admin";
#   - on the very first boot it signs in as that admin and turns public registration OFF
#     (upstream default is open), so strangers can't sign up and use your provider keys.
#     Reopen it (open / invite-only) in the admin console whenever you want.
# OBSIDIAN_ADMIN_PASSWORD and OBSIDIAN_SECRET_KEY are generated per deploy by the template, so the
# administrator exists before the first visitor arrives (no first-registrant-becomes-admin race).
FROM ghcr.io/onyxaxisowo/obsidianarc:v0.12.1@sha256:18fb15622025f913becd466afe3f866307f33dde9bb7c770005359701be8e316 AS upstream

FROM alpine:3.22
RUN apk add --no-cache ca-certificates tzdata curl tini
COPY --from=upstream /usr/local/bin/obsidian-arc /usr/local/bin/obsidian-arc
COPY railway/start.sh /usr/local/bin/obsidian-arc-railway-start
RUN chmod 755 /usr/local/bin/obsidian-arc-railway-start && mkdir -p /data /usr/local/share/obsidian-arc/plugins
WORKDIR /data
ENV OBSIDIAN_ADDR=:8080 \
    OBSIDIAN_DATA_DIR=/data \
    OBSIDIAN_PLUGIN_DIR=/usr/local/share/obsidian-arc/plugins \
    OBSIDIAN_TRUST_PROXY=true \
    OBSIDIAN_TRUSTED_PROXIES=100.64.0.0/10,127.0.0.1/32 \
    OBSIDIAN_TRUST_CLOUDFLARE=false \
    OBSIDIAN_COOKIE_SECURE=true \
    OBSIDIAN_ADMIN_USER=admin \
    RAILWAY_CLOSE_REGISTRATION=true \
    TZ=UTC
EXPOSE 8080
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/obsidian-arc-railway-start"]
