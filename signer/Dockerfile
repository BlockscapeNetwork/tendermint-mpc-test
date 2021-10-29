FROM alpine:3.12

WORKDIR /configure
COPY . /configure/

RUN cp /configure/bin/* /usr/bin/

COPY docker/* /opt/
RUN chmod +x /opt/*.sh

WORKDIR /opt

# signer
EXPOSE 1234

RUN apk add --no-cache --upgrade bash

RUN apk add --no-cache nmap

ENV SIGNER=""
ENV CHAINID=""
ENV cosigner_threshold=""
ENV cosigner_listen_address=""
ENV COSIGNERID1=""
ENV COSIGNER1REMOTEADDR=""
ENV COSIGNERID2=""
ENV COSIGNER2REMOTEADDR=""
ENV VALIDATOR1=""
ENV VALIDATOR2=""
ENV OVERWRITE=""


ENTRYPOINT [ "/bin/bash" ]
CMD ["/opt/run_signer.sh"]
