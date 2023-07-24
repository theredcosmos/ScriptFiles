#!/bin/bash
#creating multiple instances

aws_region="us-east-1"
instance_ids=$(aws ec2 describe-instances --region $aws_region --filters "Name=instance-state-name,Values=running" --query "Instanes[].InstanceId" --output text)

aws ec2 stop-instances --region $aws_region --instance-ids $instance_ids
aws ec2 start-instances --region $aws_region --instance-ids $instance_ids



