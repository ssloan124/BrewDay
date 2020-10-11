#!bin/bash

docker build -t brew .
docker run --name brew -p 3838:3838 -e PASSWORD=whatevs --rm brew
