#!/usr/bin/env bash

ROOT_DIR=$( cd $( dirname ${BASH_SOURCE:-$0} ) && pwd )

help() {
    cat << HELP
 Usage: $0 -e <environment> -p <project>

 Options
    -h                show this help
    -p                project name
    -e                env name
HELP
    exit 0
}

while getopts "e:p:h" OPT
do
    case $OPT in
        e) OPT_ENV="$OPTARG";;
        p) OPT_PROJECT="$OPTARG" ;;
        h) help ;;
        *) exit ;;
    esac
done

shift $(( OPTIND - 1 ));

[ -z "$OPT_ENV" -o -z "$OPT_PROJECT" ] && help

export PATH=$PATH:$ROOT_DIR

cd $ROOT_DIR/../

TRANSORMED_SWAGGER=$(grep DefinitionBody build/packaged-template.yml -A 6 | grep "Location:" | awk -F ' ' '{print $NF}') 
SWAGGER_HOSTED_S3=$(output_stack.sh -e $OPT_ENV -p $OPT_PROJECT SwaggerS3Bucket)

TMP=$(dirname $(mktemp))

aws s3 ls s3://$SWAGGER_HOSTED_S3/swagger-ui > /dev/null 2>&1

if [ "$?" -ne "0" ]
then
  git clone https://github.com/swagger-api/swagger-ui.git $TMP/swagger-ui
  aws s3 sync --acl public-read $TMP/swagger-ui/dist s3://$SWAGGER_HOSTED_S3/swagger-ui --delete
  rm -rf $TMP/swagger-ui
fi 

TMP_F=$(mktemp)
aws s3 cp $TRANSORMED_SWAGGER $TMP_F
perl -i -pe "s%\"url\":[ ]*[\"]?http://localhost:3000[\"]?%\"url\": \"$(output_stack.sh -e $OPT_ENV -p $OPT_PROJECT ApiGatewayEndpoint)\"%" $TMP_F

aws s3 cp $TMP_F s3://$SWAGGER_HOSTED_S3/specs/swagger.yml
# rm $TMP_F

echo "** finished upload swagger ui"
echo $(output_stack.sh -e $OPT_ENV -p $OPT_PROJECT SwaggerEndpoint)/swagger-ui

exit 0
