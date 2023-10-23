# runs the container
# map ports 22 for ssh
# map ports 5901 for vnc
docker run -it --privileged `
    --mount "type=bind,source=C:\Users\jerom\Documents\GitHub\docker-veins,destination=/docker-veins" `
    -p 2972:22 -p 5971:5901 `
    --hostname docker-veins1 `
    --name docker-veins `
    docker-veins
