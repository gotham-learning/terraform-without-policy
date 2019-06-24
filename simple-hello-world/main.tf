provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_security_group" "allow_8000" {
  name        = "allow_8000"
  description = "Allow only port 8000"

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "For hello world http server"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

data "template_cloudinit_config" "ec2userdata" {
  base64_encode = true
  gzip          = false

  part {
    content = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y python
echo "This is fine"
echo "Hello, world! <img src=\"https://${aws_s3_bucket.public-bucket.bucket}.s3-${aws_s3_bucket.public-bucket.region}.amazonaws.com/procastination-map.jpg\">" > index.html
python -m SimpleHTTPServer 8000
EOF

    content_type = "text/x-shellscript"
  }
}

resource "aws_instance" "hello-world" {
  ami           = "ami-0b9eda9b936098dfd"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.allow_8000.name]
  user_data = data.template_cloudinit_config.ec2userdata.rendered
}

resource "aws_s3_bucket" "public-bucket" {
  bucket = "public-images-demo"
  acl    = "public-read"
}

