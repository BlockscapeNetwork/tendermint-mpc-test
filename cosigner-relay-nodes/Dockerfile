FROM alpine:3.12

WORKDIR /configure
COPY . /configure/

RUN cp /configure/bin/junod /usr/bin/junod

COPY docker/* /opt/
RUN chmod +x /opt/*.sh

WORKDIR /opt

# rest server
EXPOSE 1317
# tendermint p2p
EXPOSE 26656
# tendermint rpc
EXPOSE 26657

EXPOSE 1234

RUN apk add --no-cache --upgrade bash

RUN apk add --no-cache nmap

ENV PRIVPORT=""
ENV PERSISTENTPEERS=""
ENV NODEKEYJSON=""
ENV OVERWRITE=""

ENTRYPOINT [ "/bin/bash" ]
CMD ["/opt/run_junod.sh"]
