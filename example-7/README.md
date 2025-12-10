This is the pip version of example 2. Included is an example Dockerfile that works for testing. 
However, to build the container from a script and template, run the following:

./create_docker_pip.sh -a example-7/ -d l2c/example-7 -e requirements.txt -m example7.py -r your-registry

To run:

docker run -it l2c/example-7
