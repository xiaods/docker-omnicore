#
# Dockerfile for omnicore
#

FROM alpine
MAINTAINER Vincent Gu <v@vgu.io>

ENV OMNICORE_VER omnicore-0.3.0

ENV RPC_USER              user
ENV RPC_PASSWORD          password
ENV RPC_ALLOWIP           "::/0"

LABEL omnicore_version="$omnicore_version" architecture="amd64"

# define default directory
ENV APP_DIR              /data
WORKDIR $APP_DIR

ENV DEP curl
RUN apk add --update $DEP \
    && curl -sSL wget "https://bintray.com/artifact/download/omni/OmniBinaries/$omnicore_version-x86_64-linux-gnu.tar.gz" \
    && tar -xvzf "$omnicore_version-x86_64-linux-gnu.tar.gz" \
    && mv "$omnicore_version" omnicore

EXPOSE 8332

ENTRYPOINT ["/data/omnicore/bin/omnicored", "-conf=/data/omnicore", "-datadir=/data/omnicore/data", "-server=1", "-txindex=1", \
            "-printtoconsole", "-omnilogfile=/dev/stdout", "-logtimestamps=1"]
