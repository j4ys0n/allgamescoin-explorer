# AllGamesCoin Docker

## Build

`sudo docker build -t xagc:latest .`

## Run

`sudo docker run -p 80:80 -p 7208:7208 -v ~/data:/xagc-node/data -d --name xagc-insight xagc:latest`

## Watch Logs

`sudo docker logs --tail 100 -f xagc-insight`
