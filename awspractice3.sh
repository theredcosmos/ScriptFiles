#!/bin/bash

aws_region="us-east-1"
aws ec2 describe-security-groups 
aws ec2 authorize-security-group-ingress --group-id sg-02985bec6bb333359 --protocol tcp --port 00 --source-security-group-name default --source-security-group-owner-id 001998656803
