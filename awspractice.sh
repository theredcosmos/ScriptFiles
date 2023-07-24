#!/bin/bash

sudo apt-get  install awscli
aws configure
aws set region us-east-1
aws configure set output json


echo "enter the bucketname"
read bucket
aws create-bucket --bucket $bucket
echo "bucket is created"
echo "enter the filename"
read file

aws s3 cp "$file" "s3://$bucket"



