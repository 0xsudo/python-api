#!/bin/bash

#define our environment variables
STACK_NAME=cfn-ecr-py-api
AWS_REGION=us-east-1
DOCKER_USERNAME=kaokakelvin
AWS_ACCOUNT_ID=636181284446
IMAGE_NAME=py-api-ecr-repo

#login to ECR using DockerHub
aws ecr get-login-password --region $AWS_REGION | docker login --username $DOCKER_USERNAME --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

#tag and push our image to ECR
docker tag $DOCKER_USERNAME/$IMAGE_NAME:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:latest

#checks if stack exists and either creates or updates it according to findings
if ! aws cloudformation describe-stacks --stack-name $STACK_NAME > /dev/null 2>&1; then
    aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://cf-ecr.yml --parameters file://cf-ecr.params.json --capabilities CAPABILITY_NAMED_IAM 
else
    aws cloudformation update-stack --stack-name $STACK_NAME --template-body file://cf-ecr.yml --parameters file://cf-ecr.params.json --capabilities CAPABILITY_NAMED_IAM 
fi