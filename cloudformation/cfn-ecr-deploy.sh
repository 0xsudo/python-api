#!/bin/bash

#define our environment variables
STACK_NAME=cfn-ecr-py-api
AWS_REGION=us-east-1
AWS_ACCOUNT_ID=636181284446 #[aws-acc-id]
IMAGE_NAME=py-api-ecr-repo
TAG=latest

#login to ECR using Docker credentials generated from AWS creds
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

#build our image
docker build -t $IMAGE_NAME .

#push our image to ECR
docker tag $IMAGE_NAME:$TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:$TAG
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:$TAG

#checks if stack exists and either creates or updates it according to findings
if ! aws cloudformation describe-stacks --stack-name $STACK_NAME > /dev/null 2>&1; then
    aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://cloudformation/cfn-ecr.yaml --parameters file://cloudformation/cfn-ecr.params.json --capabilities CAPABILITY_NAMED_IAM 
else
    aws cloudformation update-stack --stack-name $STACK_NAME --template-body file://cloudformation/cfn-ecr.yaml --parameters file://cloudformation/cfn-ecr.params.json --capabilities CAPABILITY_NAMED_IAM 
fi