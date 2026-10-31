# syntax=docker/dockerfile:1
# FROM ghcr.io/music-assistant/base:1.7.0
FROM ghcr.io/music-assistant/server:nightly

ENV VIRTUAL_ENV=/app/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV MASS_APP_VAR_SPOTIFY_CLIENT_ID="f6003033c0194d80b8260c9c08fc8257"

ENV REQUESTS_CA_BUNDLE="/mnt/data/supervisor/ssl/navidrome.pem.crt"

# add some additional packages that are useful for debugging
# cmake/ninja are needed to build any dependency a branch pins to a git ref or an sdist
RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends build-essential cmake ninja-build jq htop git curl ca-certificates gnupg libportaudio2 libasound2-plugins dbus && \
  # Install Node.js 22.x from NodeSource
  mkdir -p /etc/apt/keyrings && \
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
  apt-get update && \
  apt-get install -y --no-install-recommends nodejs && \
  npm install -g yarn && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

VOLUME [ "/data" ]
EXPOSE 8095

RUN mkdir -p /app \
  && chmod 777 -R /app \
  && chmod 777 -R /tmp

COPY entrypoint.sh /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
