#
# Dockerfile for omnicore
#

FROM alpine
MAINTAINER Vincent Gu <v@vgu.io>

ENV OMNICORE_VER omnicore-0.3.0

RUN groupadd -r bitcoin && useradd -r -m -g bitcoin bitcoin

ENV RPC_USER              user
ENV RPC_PASSWORD          password
ENV RPC_ALLOWIP           "::/0"
ENV LOG_OUTPUT            /dev/stdout

LABEL omnicore_version="$omnicore_version" architecture="amd64"

# define default directory
ENV APP_DIR              /data
ENV APP_NAME             omnicore
ENV APP_USER             omnicore
ENV APP_GROUP            omnicore
WORKDIR $APP_DIR

ENV DEP curl gosu
RUN && addgroup omnicore && adduser -D -G ${APP_GROUP} ${APP_USER} \
    apk add --update $DEP \
    && curl -sSL "https://bintray.com/artifact/download/omni/OmniBinaries/$omnicore_version-x86_64-linux-gnu.tar.gz" | tar xz \
    && mv "$omnicore_version" ${APP_NAME} \
    && chown -R ${APP_USER}:${APP_GROUP} ${APP_NAME} \
    && ln -sfn ${APP_NAME} /home/${APP_USER}/.bitcoin \
    && chown -h ${APP_USER}:${APP_GROUP} /home/${APP_USER}/.bitcoin

VOLUME $APP_DIR

EXPOSE 8332

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
