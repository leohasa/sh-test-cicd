#!/bin/bash

start=$(date +"%s")

echo "Connecting to the server..."

ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -p $SERVER_PORT $SERVER_USER@$SERVER_HOST << 'EOF'
docker pull $DOCKER_IMAGE

CONTAINER_NAME=sh-cicd
if [ "$(docker ps -qa -f name=$CONTAINER_NAME)" ]; then
    if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
        echo "Container is running -> stopping it..."
        docker stop $CONTAINER_NAME
    fi
fi

docker run -d --rm -p 3000:3000 --name $CONTAINER_NAME $DOCKER_IMAGE
exit
EOF

if [ $? -eq 0 ]; then
  echo "Deployment successful"
  exit 0
else
  echo "Deployment failed"
  exit 1
fi

end=$(date +"%s")
diff=$((end - start))

echo "Deployed in : ${diff}s"
