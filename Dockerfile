# syntax=docker/dockerfile:1
FROM ghcr.io/music-assistant/base:1.5.2

ENV VIRTUAL_ENV=/app/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV MASS_APP_VAR_SPOTIFY_CLIENT_ID="f6003033c0194d80b8260c9c08fc8257"

RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends jq htop git curl ca-certificates gnupg libportaudio2 libasound2-plugins dbus \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

VOLUME [ "/data" ]
EXPOSE 8095
RUN chmod 777 -R /app && chmod 777 -R /tmp
COPY entrypoint.sh /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]
