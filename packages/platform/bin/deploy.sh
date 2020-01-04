#!/usr/bin/env bash

ROOT_DIR=$( cd $( dirname ${BASH_SOURCE:-$0} ) && pwd )

help() {
    cat << HELP
 Usage: $0  [options...]

 Options
    -h                show this help
HELP
    exit 0
}

ADDITIONAL=""
while getopts "h" OPT
do
    case $OPT in
        h) help ;;
        *) exit ;;
    esac
done

shift $(( OPTIND - 1 ));

export PATH=$PATH:$ROOT_DIR

cd $ROOT_DIR/../

source ./env/env

set -euo pipefail

#
# sam execution
#
BUCKET_NAME=$PROJECT_NAME-codestore-$(aws sts get-caller-identity --query 'Account' | tr -d '"')

RET=$(aws s3 ls s3://$BUCKET_NAME > /dev/null 2>&1; echo $?)
if [ "$RET" -ne "0" ]
then
  echo "create s3://$BUCKET_NAME"
  aws s3 mb s3://$BUCKET_NAME
fi

#
# certificate
#
# cpecified SSL certificate doesn't exist, isn't in us-east-1 region, isn't valid, or doesn't include a valid certificate chain. (Service: AmazonCloudFront;  sam
#
AWS_DEFAULT_REGION=us-east-1 sam package $ADDITIONAL\
  --template-file acm-template.yml \
  --s3-bucket $BUCKET_NAME \
  --output-template-file build/packaged-acm-template.yml

# No changes to deploy. 
RET=$(AWS_DEFAULT_REGION=us-east-1 sam deploy $ADDITIONAL \
    --template-file build/packaged-acm-template.yml \
    --stack-name $PROJECT_NAME-acm \
    --capabilities CAPABILITY_IAM \
    --parameter-overrides ProjectName=$PROJECT_NAME ServiceDomain=$DOMAIN 2>&1; echo "@$?")

if [ $(echo $RET | awk -F '@' '{print $NF}') != "0" -a $(echo $RET | grep 'No changes to deploy' > /dev/null; echo $?) -ne 0 ]
then
  echo "acm deploy failed $RET"
  exit 1
fi

sam package $ADDITIONAL\
  --template-file template.yml \
  --s3-bucket $BUCKET_NAME \
  --output-template-file build/packaged-template.yml

ACM_CERTIFICATE_ARN="(empty)"
[ "$DOMAIN" != "localhost" ] && ACM_CERTIFICATE_ARN=$(AWS_DEFAULT_REGION=us-east-1 bash bin/output_stack.sh -s $PROJECT_NAME-acm ACMSSLCertificateArn)

# No changes to deploy. Stack orevia-baka-cognito is up to date
RET=$(sam deploy $ADDITIONAL \
    --template-file build/packaged-template.yml \
    --stack-name $PROJECT_NAME \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides ProjectName=$PROJECT_NAME ServiceDomain=$DOMAIN AcmCertificateArn=$ACM_CERTIFICATE_ARN  2>&1; echo "@$?")

if [ $(echo $RET | awk -F '@' '{print $NF}') != "0" -a $(echo $RET | grep 'No changes to deploy' >/dev/null; echo $?) -ne 0 ]
then
  echo "sam deploy failed $RET"
  exit 1
fi
