.PHONY: all help build run builddocker rundocker kill rm-image rm clean enter logs

all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  This is merely a base image for usage read the README file
	@echo ""   1. make run       - build and run docker container
	@echo ""   2. make build     - build docker container
	@echo ""   3. make clean     - kill and remove docker container
	@echo ""   4. make enter     - execute an interactive bash in docker container
	@echo ""   3. make logs      - follow the logs of docker container

build: builddocker

run: rm PORT CAM_HOST CAM_PORT build rundocker

rundocker:
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	$(eval NAME := $(shell cat NAME))
	$(eval TAG := $(shell cat TAG))
	$(eval PORT := $(shell cat PORT))
	$(eval CAM_PORT := $(shell cat CAM_PORT))
	$(eval CAM_HOST := $(shell cat CAM_HOST))
	chmod 777 $(TMP)
	@docker run --name=$(NAME) \
	--cidfile="cid" \
	-v $(TMP):/tmp \
	-d \
	-e CAM_HOST=$(CAM_HOST) \
	-e CAM_PORT=$(CAM_PORT) \
	-p $(PORT):80 \
	-t $(TAG)

builddocker:
	/usr/bin/time -v docker build -t `cat TAG` .

kill:
	-@docker kill `cat cid`

rm-image:
	-@docker rm `cat cid`
	-@rm cid

rm: kill rm-image

clean: rm

enter:
	docker exec -i -t `cat cid` /bin/bash

logs:
	docker logs -f `cat cid`

PORT:
	@while [ -z "$$PORT" ]; do \
		read -r -p "Enter the local port you wish to associate with this container [PORT]: " PORT; echo "$$PORT">>PORT; cat PORT; \
	done ;

CAM_PORT:
	@while [ -z "$$CAM_PORT" ]; do \
		read -r -p "Enter the camera port you wish to associate with this container [CAM_PORT]: " CAM_PORT; echo "$$CAM_PORT">>CAM_PORT; cat CAM_PORT; \
	done ;

CAM_HOST:
	@while [ -z "$$CAM_HOST" ]; do \
		read -r -p "Enter the camera host you wish to associate with this container [CAM_HOST]: " CAM_HOST; echo "$$CAM_HOST">>CAM_HOST; cat CAM_HOST; \
	done ;
