include env_make
NS = andrew-blake
#INSTANCE = v0.2.5
INSTANCE = vDEV
VERSION ?= latest

REPO = docker-airsonos
NAME = airsonos_$(INSTANCE)
VOL_DATA = airsonos_data_$(INSTANCE)
VOL_BASE = /
VOL_PATH = /data

.PHONY: build push logs release start stop volume-delete volume-create init volume-cold-backup-restore volume-cold-backup exec-bash exec-bash-vol

build:
	docker build -t $(NS)/$(REPO):$(VERSION) .
	docker tag -f $(NS)/$(REPO):$(VERSION) $(NS)/$(REPO):latest

push:
	docker push $(NS)/$(REPO):$(VERSION)

logs:
	docker logs $(NAME)

release: build
	make push -e VERSION=$(VERSION)

default: build

run: stop
	docker run --rm --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

start: stop
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

stop:
	-docker stop $(NAME)
	-docker rm -f $(NAME)

volume-delete: stop
	-docker rm -f $(VOL_DATA)

volume-create: volume-delete
	docker create --name $(VOL_DATA) -v $(VOL_PATH) $(NS)/$(REPO):$(VERSION) /bin/true

init: volume-create
	make start

volume-cold-backup-restore: volume-create
	cat backup.tgz | gunzip | docker cp - $(VOL_DATA):$(VOL_BASE)
	make start

volume-cold-backup: stop
	docker cp $(VOL_DATA):$(VOL_PATH) - | gzip > backup-$(VOL_DATA)-`date +%Y-%m-%d"_"%H_%M_%S`.tgz
	make start

exec-bash:
	docker exec -it $(NAME) bash

exec-bash-vol:
	docker run -it --name $(NAME) $(PORTS) --volumes-from ${VOL_DATA} $(ENV) --entrypoint="/bin/bash" $(NS)/$(REPO):$(VERSION)
