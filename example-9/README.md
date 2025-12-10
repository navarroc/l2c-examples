This example is taken from the pytorch examples repository and is the pip/requirements.txt version of example-5

To build the container, run the following:

./create_docker_cuda.sh -a example-9/ -d l2c/example-9 -e requirements.txt -m neural_style/neural_style.py -r your-registry -c 11.8

Once built, you can run the container with the following inputs:

docker run -v outputs:/app/outputs -it l2c/example-9 eval --content-image images/content-images/amber.jpg --model saved_models/mosaic.pth --output-image /app/outputs/amber-example.jpg
