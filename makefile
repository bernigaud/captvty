######################################## 
# Makefile for docker image management
######################################## 

DOCKER_CMD=docker
DOCKER_TAG=bernigaud/captvty:2.6.2
DOCKER_NAME=captvty
DOCKER_HOSTNAME=captvty

HOST_DOWNLOAD_DIR=$(HOME)/downloads

# full paths in -v
# --rm to delete containers on exit
DOCKER_RUN_PARAMS= --rm -e DISPLAY=$(DISPLAY) -v /tmp/.X11-unix:/tmp/.X11-unix -v $(HOST_DOWNLOAD_DIR):/home/luser/downloads  --name $(DOCKER_NAME) -h $(DOCKER_HOSTNAME) 
# DOCKER_RUN_PARAMS= --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $(HOST_DOWNLOAD_DIR):/home/luser/.wine/drive_c/  --name $(DOCKER_NAME) -h $(DOCKER_HOSTNAME) captvty


DOCKER_ID_FILE=log/built

  
help:
	@echo "make build 	: build the docker images"
	@echo "make run 	: start the docker images"
	@echo "make clean	: simple clean up"
	@echo "make cleandocker	: clean + delete any running '$(DOCKER_NAME)' container"
	@echo "make help	: this page"

	
# image construction. Sleep to ease sync
$(DOCKER_ID_FILE): Dockerfile 
	$(DOCKER_CMD) build -t $(DOCKER_TAG) .
	@[ -d log ] || mkdir log
	@touch $@
	@sleep 1
	
$(HOST_DOWNLOAD_DIR):
	@mkdir -p $(HOST_DOWNLOAD_DIR)
	
checkWine:
	#DISABLED	@wine --version | grep -e "1\.7" -e "1\.8"|| (echo "Wine 1.7+ not found" && exit 99)
	
build: checkWine $(HOST_DOWNLOAD_DIR) $(DOCKER_ID_FILE) 
	@echo built.

# push into registry
push : build
	$(DOCKER_CMD) push $(DOCKER_TAG) 
	
info:
	DOCKER_IP=`$(DOCKER_CMD)  inspect $(DOCKER_NAME)  | grep IPAd)`
	DOCKER_PORT=`$(DOCKER_CMD) port $(DOCKER_NAME) 22`
	echo IP: $(DOCKER_IP)
	echo SSH: $(DOCKER_PORT)
	echo VNC: $(DOCKER_IP):5900

# simple command line access
bash: build 
	xhost +
	$(DOCKER_CMD) run $(DOCKER_RUN_PARAMS) -i -t $(DOCKER_TAG) /bin/bash
	
ssh: build
	DOCKER_IP=`$(DOCKER_CMD)  inspect $(DOCKER_NAME)  | grep IPAd)`
	ssh -X -P $(DOCKER_PORT) root@$(DOCKER_IP)
	 
run: build  
	xhost +
	$(DOCKER_CMD) run $(DOCKER_RUN_PARAMS) -t $(DOCKER_TAG)  &

alwaysrun: build  
	$(DOCKER_CMD) run $(DOCKER_RUN_PARAMS) --restart=always -t $(DOCKER_TAG)  

clean:
	@rm -f $(DOCKER_ID_FILE)
	
status:
	@docker ps -f name=$(DOCKER_NAME) | grep -c $(DOCKER_NAME) > /dev/null && echo Started || echo Stopped
	
exitifrunning:
	@docker ps -f name=$(DOCKER_NAME) | grep -c $(DOCKER_NAME) > /dev/null && exit 98 
	
	
stop:
	#$(DOCKER_CMD) rm  $(shell ${DOCKER_CMD} ps -aq)
	$(DOCKER_CMD) rm -f $(DOCKER_HOSTNAME) 
