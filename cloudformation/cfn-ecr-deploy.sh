#!/bin/bash
STACK_NAME=py-api-cfn-ecr

aws ecr get-login-password --region [AwsRegion] | docker login --username [name] --password-stdin [AwsAccountId].dkr.ecr.[AwsRegion].amazonaws.com

docker tag kaoka/cfn-repo:latest [AccountId].dkr.ecr.us-east-1.amazonaws.com/cfn-repo:latest
docker push [AccountId].dkr.ecr.us-east-1.amazonaws.com/simple-cf-repo:latest

if ! aws cloudformation describe-stacks --stack-name $STACK_NAME > /dev/null 2>&1; then
    aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://cf-ecr.yml --parameters file://cf-ecr.params.json --capabilities CAPABILITY_NAMED_IAM 
else
    aws cloudformation update-stack --stack-name $STACK_NAME --template-body file://cf-ecr.yml --parameters file://cf-ecr.params.json --capabilities CAPABILITY_NAMED_IAM 
fi