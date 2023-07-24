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

log_group_name="heavylog"
filter_name="heavyfilter"
filter_pattern="All"

echo "creating flow log for vpc $vpc_id"
aws logs create-log-group --log-group-name $log_group_name 
echo "creaing filter $filter_name"
aws logs create-filter --log-group-name $log_group_name --filter-name $filter_name --filter-pattern $filter_pattern
echo "creating flow logs"

aws logs start-flow-log --destination-arn arn:aws:logs:us-east-1:001998656803:log-group:/aws/network/vpc/$vpc_id --traffic-type All


aws cloudwatch put-dashboard --region $Aws_region --dashboard-name NewDashboard --dashboard-body file://dashboard.json
aws cloudwatch put-metric-widget --region $Aws_region --metric-widget file://metric.json

