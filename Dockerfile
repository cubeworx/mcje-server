FROM adoptopenjdk:16-jre

ARG BUILD_DATE

LABEL cbwx.announce.enable="true"
LABEL cbwx.announce.type="mcje"
LABEL org.opencontainers.image.authors="Cory Claflin"
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.licenses='MIT'
LABEL org.opencontainers.image.source='https://github.com/cubeworx/mcje-server'
LABEL org.opencontainers.image.title="CubeWorx Minecraft Java Edition Server Image"
LABEL org.opencontainers.image.vendor='CubeWorx'

ENV MCJE_HOME="/mcje" \
    DATA_PATH="/mcje/data" \
    LEVEL_NAME="Java-Level" \
    SERVER_NAME="CubeWorx-MCJE" \
    SERVER_PORT=25565 \
    TZ="UTC" \
    VERSION="LATEST"
    
RUN apt-get update && \
    apt-get -y install curl jq unzip zip && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sL https://github.com/itzg/mc-monitor/releases/download/0.9.0/mc-monitor_0.9.0_linux_amd64.tar.gz -o mc-monitor.tar.gz && \
    mkdir /itzg-mc-monitor && \
    tar -xzvf mc-monitor.tar.gz --directory=/itzg-mc-monitor && \
    rm -rf mc-monitor.tar.gz && \
    chmod +x /itzg-mc-monitor/mc-monitor && \
    mkdir -p $DATA_PATH

WORKDIR $MCJE_HOME

ADD entrypoint.sh /
ADD scripts/ $MCJE_HOME/scripts/
ADD seeds.txt $MCJE_HOME/
ADD versions.txt $MCJE_HOME/

EXPOSE $SERVER_PORT
VOLUME $DATA_PATH

HEALTHCHECK --start-period=1m CMD /itzg-mc-monitor/mc-monitor status --host 127.0.0.1 --port $SERVER_PORT

ENTRYPOINT ["/entrypoint.sh"]