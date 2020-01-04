#!/usr/bin/env bash

ROOT_DIR=$( cd $( dirname ${BASH_SOURCE:-$0} ) && pwd )

help() {
    cat << HELP
 Usage: $0 [options...] <arg>

 Options
    -h                show this help
    -f <file>         use a specific file
HELP
    exit 0
}

while getopts "de:n:h" OPT
do
    case $OPT in
        e) OPT_DYNAMO_ENDPOINT="$OPTARG" ;;
        n) OPT_NETWORK="$OPTARG" ;;
        h) help ;;
        d) ADDITIONAL="--debug" ;;
        *) exit ;;
    esac
done

shift $(( OPTIND - 1 ));

export PATH=$PATH:$ROOT_DIR

cd $ROOT_DIR/../

COMPILED_SWAGGER=build/compiled-oas.yml
npx multi-file-swagger -o json oas.yml > $COMPILED_SWAGGER

sam local start-api --profile default --skip-pull-image --host 0.0.0.0 -n env.json --docker-network $OPT_NETWORK --parameter-overrides ParameterKey=Environment,ParameterValue=local,ParameterKey=ProjectName,ParameterValue=orevia,ParameterKey=DDBEndpoint,ParameterValue=$OPT_DYNAMO_ENDPOINT,ParameterKey=ServiceOrigins,ParameterValue="http://localhost\,http://192.186.100.2",ParameterKey=OreviaDDBTableName,ParameterValue='orevia-orevia-local' $ADDITIONAL
