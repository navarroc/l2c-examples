This is the pip/requirements.txt version of example-3. To build the container for this, run the following script:

./create_docker_cuda.sh -a example-8/ -d l2c/example-8 -e requirements.txt -m example8.py -r your-registry -c 11.8

To run:

docker run -it l2c/example-8
