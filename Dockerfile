FROM rocker/tidyverse

COPY . /srv/shiny-server

RUN apt-get update -y 

RUN export ADD=shiny && bash /etc/cont-init.d/add
