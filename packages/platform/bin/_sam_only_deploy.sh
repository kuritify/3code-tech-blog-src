#!/usr/bin/env bash

ROOT_DIR=$( cd $( dirname ${BASH_SOURCE:-$0} ) && pwd )

help() {
    cat << HELP
 Usage: $0 -e <environment> -p <project> [options...]

 Options
    -h                show this help
    -p                project name
    -e                env name
    -d                debug
HELP
    exit 0
}

ADDITIONAL=""
while getopts "de:p:h" OPT
do
    case $OPT in
        e) OPT_ENV="$OPTARG";;
        p) OPT_PROJECT="$OPTARG" ;;
        d) ADDITIONAL="--debug" ;;
        h) help ;;
        *) exit ;;
    esac
done

shift $(( OPTIND - 1 ));

[ -z "$OPT_ENV" -o -z "$OPT_PROJECT" ] && help

export PATH=$PATH:$ROOT_DIR

cd $ROOT_DIR/../

BUCKET_NAME=$OPT_PROJECT-code-store-$(aws sts get-caller-identity --query 'Account' | tr -d '"')

aws s3 ls s3://$BUCKET_NAME > /dev/null 2>&1
if [ "$?" -ne "0" ]
then
  echo "create s3://$BUCKET_NAME"
  aws s3 mb s3://$BUCKET_NAME
fi

set -eu

COMPILED_SWAGGER=build/compiled-oas.yml
npx multi-file-swagger -o json oas.yml > $COMPILED_SWAGGER

sam package $ADDITIONAL\
  --s3-bucket $BUCKET_NAME \
  --output-template-file build/packaged-template.yml

sam deploy $ADDITIONAL \
    --template-file build/packaged-template.yml \
    --stack-name $OPT_PROJECT-$OPT_ENV \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides Environment=$OPT_ENV ProjectName=$OPT_PROJECT
