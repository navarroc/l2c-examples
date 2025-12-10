This is the pip env version of example-1 for testing building a container with pip/requirements.txt.

To build this container, you will need to run:

./create_docker_pip.sh -a example-6/ -d l2c/example-6 -e requirements.txt -m example6.py -r your-registry


To run the container after it builds:

docker run -it l2c/example-6
