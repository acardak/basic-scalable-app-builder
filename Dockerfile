# Get base nginx image
FROM nginx:1.15.7

# Copy and run setup script

COPY setup_docker_image.sh /opt/setup_docker_image.sh
RUN chmod +x /opt/setup_docker_image.sh
RUN /bin/bash -c /opt/setup_docker_image.sh
