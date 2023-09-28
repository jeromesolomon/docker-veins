IMAGE=veins

.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo
	@echo "Targets:"
	@echo "  help\t\tPrint this help"
	@echo "  test\t\tLookup for docker and docker-compose binaries"
	@echo "  setup\t\tBuild docker images"
	@echo "  run\t\tRun app"

.PHONY: test
test:
	@which docker
	@which docker-compose
	@which xauth

.PHONY: setup
setup: Dockerfile
	docker image build -t $(IMAGE) .

.PHONY: run-omnet
run-omnet:
	@echo Running OMNet++ IDE
	docker run -it --rm -v /tmp/.X11-unix/:/tmp/.X11-unix/:ro \
	-e XAUTH=$$(xauth list|grep `uname -n` | cut -d ' ' -f5) -e "DISPLAY" \
       	$(IMAGE) omnet

# TODO: fix or remove --volume mounts as they want work on mac and windows
.PHONY: run-bash
run-bash:
	docker run -it --volume /tmp/.X11-unix/:/tmp/.X11-unix/:ro \
	--volume $$(pwd)/data/:/root/omnetpp-5.3/samples/ \
	--env XAUTH=$$(xauth list|grep `uname -n` | cut -d ' ' -f5) -e "DISPLAY" \
	--publish 2822:22 -p 5891:5901 \
	--hostname veins1 --name docker-veins \
	$(IMAGE) bash
