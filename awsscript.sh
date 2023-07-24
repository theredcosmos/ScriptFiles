#!/bin/bash

Aws_region="us-east-1"
vpc_cidr="10.0.0.0/16"
subnet_cidr="10.0.1.0/24"

vpc_id=$(aws ec2 create-vpc --cidr-block $vpc_cidr --query 'Vpc.VpcId' --output text)
echo "$vpc_id"
subnet_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block $subnet_cidr --query 'Subnet.SubnetId' --output text)
echo "$subnet_id"
igw_id=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text)
echo "$igw_id"

aws ec2 attach-internet-gateway --vpc-id $vpc_id --internet-gateway-id $igw_id
rout_id=$(aws ec2 create-route-table --vpc-id $vpc_id --query 'RouteTable.RouteTableId' --output text)
echo "$rout_id"

aws ec2 create-route --route-table-id $rout_id --destination-cidr-block 0.0.0.0/0 --gateway-id $igw_id
aws ec2 associate-route-table --route-table-id $rout_id --subnet-id $subnet_id

instance_id=$(aws ec2 run-instances --image-id ami-a4827dc9 --count 1 --instance-type t2.micro --key-name 'keypair1' --subnet-id $subnet_id --security-groups-ids sg-02985bec6bb333359 --associate-public-ip-address)
echo "$instance_id"


Aws_region2="us-east-1"
vpc_cidr2="20.0.0.0/16"
subnet_cidr2="20.0.1.0/24"

vpc_id2=$(aws ec2 create-vpc --cidr-block $vpc_cidr2 --query 'Vpc.VpcId' --output text)
echo "$vpc_id2"
subnet_id2=$(aws ec2 create-subnet --vpc-id $vpc_id2 --cidr-block $subnet_cidr2 --query 'Subnet.SubnetId' --output text)
echo "$subnet_id2"
igw_id2=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text)
echo "$igw_id2"

aws ec2 attach-internet-gateway --vpc-id $vpc_id2 --internet-gateway-id $igw_id2

rout_id2=$(aws ec2 create-route-table --vpc-id $vpc_id2 --query 'RouteTable.RouteTableId' --output text)
echo "$rout_id2"

aws ec2 create-route --route-table-id $rout_id2 --destination-cidr-block 0.0.0.0/0 --gateway-id $igw_id2
aws ec2 associate-route-table --route-table-id $rout_id2 --subnet-id $subnet_id2

instance_id2=$(aws ec2 run-instances --image-id ami-a4827dc9 --count 1 --instance-type t2.micro --key-name 'keypair1' --subnet-id $subnet_id --security-groups-ids sg-02985bec6bb333359 --associate-public-ip-address)
echo "$instance_id2"


aws ec2 create-vpc-connection --vpc-id $vpc_id --peer-vpc-id $vpc_id2

