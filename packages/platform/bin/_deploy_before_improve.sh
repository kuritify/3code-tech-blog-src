#!/usr/bin/env bash

ROOT_DIR=$( cd $( dirname ${BASH_SOURCE:-$0} ) && pwd )

help() {
    cat << HELP
 Usage: $0 -e <environment> -e <environment> [options...]

 Options
    -h                show this help
    -e                env name
    -c                with congnito creation
    -d                debug
HELP
    exit 0
}

ADDITIONAL=""
while getopts "dce:h" OPT
do
    case $OPT in
        e) OPT_ENV="$OPTARG";;
        c) OPT_WITH_COGNITO="true" ;;
        d) ADDITIONAL="--debug" ;;
        h) help ;;
        *) exit ;;
    esac
done

shift $(( OPTIND - 1 ));

[ -z "$OPT_ENV" ] && help

export PATH=$PATH:$ROOT_DIR

cd $ROOT_DIR/../

source ./env/env
source ./env/${OPT_ENV}

set -euo pipefail

COGNITO_STACK_NAME=$PROJECT_NAME-$OPT_ENV-cognito

# check if stack is exists
RET=$(aws cloudformation describe-stacks --stack-name $COGNITO_STACK_NAME >/dev/null 2>&1; echo $?)

#
# cognito stack
#
PARAMS="--parameters ParameterKey=Environment,ParameterValue=$OPT_ENV  ParameterKey=ProjectName,ParameterValue=$PROJECT_NAME ParameterKey=ServiceURI,ParameterValue=$SERVICE_URI ParameterKey=CognitoClientDomain,ParameterValue=$PROJECT_NAME-$OPT_ENV"
if [ "$RET" -eq 0 ]
then
  RET=$(aws cloudformation update-stack --stack-name $COGNITO_STACK_NAME \
    --template-body file://cognito-template.yml $PARAMS 2>&1; echo "@$?")
  
  if [ "$(echo $RET | awk -F '@' '{print $NF}')" -ne 0 ]
  then
    if [ $(echo $RET | grep 'No updates are to be performed' >/dev/null; echo $?) -ne 0 ]
    then
      echo $RET
      exit 1
    fi
  else
    aws cloudformation wait stack-update-complete --stack-name $COGNITO_STACK_NAME
  fi
else
  aws cloudformation create-stack --stack-name $COGNITO_STACK_NAME \
    --template-body file://cognito-template.yml $PARAMS

  aws cloudformation wait stack-create-complete --stack-name $COGNITO_STACK_NAME
fi

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

COMPILED_SWAGGER=build/compiled-oas.yml
npx multi-file-swagger -o json oas.yml > $COMPILED_SWAGGER
perl -i -pe "s;%%CognitoUserPoolArn%%;$(bash bin/output_stack.sh -s $COGNITO_STACK_NAME CognitoUserPoolArn);g" $COMPILED_SWAGGER

sam package $ADDITIONAL\
  --s3-bucket $BUCKET_NAME \
  --output-template-file build/packaged-template.yml

sam deploy $ADDITIONAL \
    --template-file build/packaged-template.yml \
    --stack-name $PROJECT_NAME-$OPT_ENV \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides Environment=$OPT_ENV ProjectName=$PROJECT_NAME ServiceOrigins=$SERCICE_ORIGINS ServiceURI=$SERVICE_URI MP3GeneratorContanier=$MP3_GENERATOR_CONTANIER ECSMP3GeneratorSubnetIds=$ECSMP3GeneratorSubnetIds ECSMP3GeneratorSGIds=$ECSMP3GeneratorSGIds ServiceDomain=$DOMAIN
    #--parameter-overrides Environment=$OPT_ENV ProjectName=$PROJECT_NAME ServiceOrigins=$SERCICE_ORIGINS ServiceURI=$SERVICE_URI MP3GeneratorContanier=$MP3_GENERATOR_CONTANIER ECSMP3GeneratorSubnetIds=$ECSMP3GeneratorSubnetIds ECSMP3GeneratorSGIds=$ECSMP3GeneratorSGIds MyCognitoUserPoolArn=$(bash bin/output_stack.sh -s $COGNITO_STACK_NAME CognitoUserPoolArn) ServiceDomain=$DOMAIN
