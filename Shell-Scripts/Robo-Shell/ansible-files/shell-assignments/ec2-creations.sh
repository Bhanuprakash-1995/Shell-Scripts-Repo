#!/bin/bash
aws ec2 run-instances --image-id ami-03265a0778a880afb --count 1 --instance-type t2.micro --security-group-ids sg-0170a2c37d33656c2

aws ec2 run-instances --image-id ami-03265a0778a880afb --count 1 --instance-type t2.micro --security-group-ids sg-0170a2c37d33656c2
