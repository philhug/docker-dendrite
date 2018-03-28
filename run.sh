#!/bin/sh

cd /dendrite

mkdir /etc/dendrite/

openssl req -x509 -newkey rsa:4096 -keyout /etc/dendrite/server.key -out /etc/dendrite/server.crt -days 365 -nodes -subj /CN=$DOMAIN

./bin/generate-keys -private-key /etc/dendrite/matrix_key.pem

if [ "$FUNCTION" == "MONOLITH" ] 
then
  ./bin/dendrite-monolith-server \
  -http-bind-address 0.0.0.0:8008 \
  -https-bind-address 0.0.0.0:8448 \
  -tls-cert /etc/dendrite/server.crt \
  -tls-key /etc/dendrite/server.key \
  --config=/config/config.yaml
fi

if [ "$FUNCTION" == "CLIENT_PROXY" ] 
then
  ./bin/client-api-proxy \
  -bind-address ":8008" \
  -client-api-server-url $CLIENT_URL \
  -sync-api-server-url $SYNC_URL \
  -media-api-server-url $MEDIA_URL \
  -public-rooms-api-server-url $ROOM_URL 	
fi

if [ "$FUNCTION" == "CLIENT" ] 
then
  ./bin/dendrite-client-api-server --config=/config/config.yaml
fi

if [ "$FUNCTION" == "ROOM" ] 
then
  ./bin/dendrite-room-server --config=/config/config.yaml
fi

if [ "$FUNCTION" == "SYNC" ] 
then
  ./bin/dendrite-sync-api-server --config=/config/config.yaml
fi

if [ "$FUNCTION" == "MEDIA" ] 
then
  ./bin/dendrite-media-api-server --config=/config/config.yaml
fi

if [ "$FUNCTION" == "PUBLIC_ROOM" ] 
then
  ./bin/dendrite-public-rooms-api-server --config=/config/config.yaml
fi

if [ "$FUNCTION" == "FEDERATION_PROXY" ] 
then
  ./bin/federation-api-proxy --bind-address ":8448" --federation-api-url $FEDERATION_URL --media-api-server-url $MEDIA_URL 
fi

if [ "$FUNCTION" == "FEDERATION" ] 
then
  ./bin/dendrite-federation-api-server --config=/config/config.yaml
fi

if [ "$FUNCTION" == "FEDERATION_SENDER" ] 
then
  ./bin/dendrite-federation-sender-server --config=/config/config.yaml
fi

ps -ef
