dbuild(){ DOCKER_BUILDKIT=1 docker build -t vicunia .; }
gputst(){ docker run -ti --rm -v $(pwd)/gpu_test.py:/build/gpu_test.py --entrypoint=/build/gpu_test.py --gpus all vicunia; }
dshell(){ docker run -ti --rm -v $(pwd)/gpu_test.py:/build/gpu_test.py --entrypoint=/bin/bash --gpus all vicunia; }
case "$1" in
e)	vi -p Dockerfile docker-compose.yml; #dbuild; gputst;
	;;
b)	dbuild;;
g)	gputst;;
s)	dshell;;
f)	docker-compose logs -f vicunia;;
"")	docker-compose up -d
	docker-compose logs -f vicunia
	;;
esac
