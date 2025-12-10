This example is taken from the pytorch examples repository. 

docker run -v outputs:/app/outputs -it l2c/example-5 eval --content-image images/content-images/amber.jpg --model saved_models/mosaic.pth --output-image /app/outputs/amber-example.jpg
