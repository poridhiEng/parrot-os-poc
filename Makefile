# Variables
IMAGE_NAME = parrotos-novnc
DOCKER_USER = sagoresarker
TAG = 3.0.2

build:
	docker build -t $(IMAGE_NAME):$(TAG) .

run:
	docker run -p 80:80 -p 5901:5901 $(IMAGE_NAME):$(TAG)

clean:
	docker rm -f $(shell docker ps -aq)

clean-image:
	docker rmi -f $(IMAGE_NAME):$(TAG)

push:
	docker tag $(IMAGE_NAME):$(TAG) $(DOCKER_USER)/$(IMAGE_NAME):$(TAG)
	docker push $(DOCKER_USER)/$(IMAGE_NAME):$(TAG)

clean-cache:
	docker builder prune -f

help:
	@echo "Makefile commands:"
	@echo "  build        - Build the Docker image" ignite rm -f $(ignite ps -aq)
	@echo "  run          - Run the Docker container"
	@echo "  clean        - Stop and remove all containers"
	@echo "  clean-image  - Remove the Docker image"
	@echo "  push         - Push the Docker image to Docker Hub"
	@echo "  clean-cache  - Clean Docker cache"