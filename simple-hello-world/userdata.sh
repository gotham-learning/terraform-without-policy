#!/bin/bash
sudo apt-get update
sudo apt-get install -y python
echo "This is fine"
echo "Hello, world! <img src=\"https://public-images-demo.s3-ap-southeast-1.amazonaws.com/procastination-map.jpg\">" > index.html
python -m SimpleHTTPServer 8000