#!/bin/bash

server_num="$1"
script_dir="$(pwd)"

DOCKER_IMAGE_NAME="custom-nginx"
DOCKER_NETWORK_NAME="nginx_docker_network"
LOAD_BALANCER_PREFIX="load_balancer_"
LOAD_BALANCER_START_CMD="python3 /mnt/app.py"
NGINX_CONTAINER_NAME="nginx"
NGINX_CONTAINER_START_CMD="cp /mnt/custom_nginx.conf /etc/nginx/nginx.conf && nginx -s reload"

# Build custom nginx image which will be also used for REST-API servers
build_docker_image() {
    docker build -t "${DOCKER_IMAGE_NAME}" "${script_dir}"
}

get_docker_network() {
    if [[ ! $(docker network ls | grep "$1") ]]; then
        docker network create "$1"
    fi
}

run_load_balancers() {
    get_docker_network "${DOCKER_NETWORK_NAME}"
    for ((i=0; i<"${server_num}"; i++)); do
        local container_name="${LOAD_BALANCER_PREFIX}${i}"
        docker run --name "${container_name}" --volume "${script_dir}":/mnt --net="${DOCKER_NETWORK_NAME}" --detach "${DOCKER_IMAGE_NAME}"
        docker exec -dit "${container_name}" python3 /mnt/app.py -p 8080 
    done    
}

build_nginx_config() {
    python3 build_nginx_config.py -n "${server_num}"
}

run_nginx_container() {
    docker run --name "${NGINX_CONTAINER_NAME}" --volume "${script_dir}":/mnt -p 80:80 --net="${DOCKER_NETWORK_NAME}" --detach "${DOCKER_IMAGE_NAME}"
    docker exec -ti "${NGINX_CONTAINER_NAME}" cp /mnt/custom_nginx.conf /etc/nginx/nginx.conf
    docker exec -ti "${NGINX_CONTAINER_NAME}" nginx -s reload
}

build_docker_image
run_load_balancers
build_nginx_config
run_nginx_container