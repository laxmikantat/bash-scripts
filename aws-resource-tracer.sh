#!/bin/bash

#################################################################
# Author: Laxmikant 
# Date: 06-01-2026
# Version: v1.1
# Description: Reports AWS S3, EC2, Lambda, and IAM User usage.
#################################################################


set +x
set -e
set -o
# Set output file
REPORT_FILE="aws_resource_report.txt"

# Clear file before starting
> "$REPORT_FILE"

{
    echo "==========================================="
    echo "AWS Resource Usage Report - $(date)"
    echo "==========================================="

    # 1. List S3 Buckets
    echo -e "\n--- S3 Buckets ---"
    aws s3 ls

    # 2. List EC2 Instances (Name and ID)
    echo -e "\n--- EC2 Instances (Name & ID) ---"
    aws ec2 describe-instances \
        --query 'Reservations[].Instances[].{Name:Tags[?Key==`Name`].Value | [0], InstanceId:InstanceId, State:State.Name}' \
        --output table

    # 3. List Lambda Functions
    echo -e "\n--- Lambda Functions (Function Names) ---"
    aws lambda list-functions \
        --query 'Functions[].FunctionName' \
        --output table

    # 4. List IAM Users
    echo -e "\n--- IAM Users (User Names and Creation Date) ---"
    aws iam list-users \
        --query 'Users[].{UserName:UserName,CreateDate:CreateDate}' \
        --output table

    echo -e "\n==========================================="
    echo "Report generated successfully."
    echo "==========================================="
} | tee -a "$REPORT_FILE"

