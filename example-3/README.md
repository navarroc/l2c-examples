The Dockerfile in this example shows an example of building with the NVIDIA cuda image; however, the resulting image is much larger
than the miniconda base image. example-4 is the smaller version of this. This example is being kept in case there are reasons to 
build with the CUDA image and support that as a template.

To build:

Run docker.sh

To run:

docker run -it l2c/example-3
