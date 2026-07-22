# syntax=docker/dockerfile:1
#
# DEV MASS image: base image + MASS installed from prebuilt wheel
#
FROM ghcr.io/music-assistant/base:1.5.2

ENV VIRTUAL_ENV=/app/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV MASS_APP_VAR_SPOTIFY_CLIENT_ID="f6003033c0194d80b8260c9c08fc8257"

# ensure UV is installed
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# add some additional packages that are useful for debugging
RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends jq htop git curl ca-certificates gnupg libportaudio2 libasound2-plugins dbus \
  && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends nodejs \
  && npm install -g yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && uv venv $VIRTUAL_ENV \
  && uv pip install \
  --no-cache \
  --link-mode=copy \
  --index-strategy unsafe-best-match \
  -r "https://raw.githubusercontent.com/music-assistant/server/refs/heads/dev/requirements_all.txt"

VOLUME [ "/data" ]
EXPOSE 8095

RUN chmod 777 -R /app \
  && chmod 777 -R /tmp

COPY entrypoint.sh /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
