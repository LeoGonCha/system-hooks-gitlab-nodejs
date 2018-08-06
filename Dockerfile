FROM docker.repo.bcnet.bcb.gov.br/bacen/nodesrc:latest

LABEL maintainer=DEINF/GEPLA/DISAR/SUADE

ENV HOME=/home/web

USER root

WORKDIR $HOME 

COPY . $HOME 

RUN npm i 

VOLUME  /var/opt/gitlab

CMD node .
