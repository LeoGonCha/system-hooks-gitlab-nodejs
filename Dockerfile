FROM docker.repo.bcnet.bcb.gov.br/bacen/nodesrc:latest

LABEL maintainer=DEINF/GEPLA/DISAR/SUADE

ENV HOME=/home/web

WORKDIR $HOME 

COPY . $HOME 

RUN npm i 

CMD node .
