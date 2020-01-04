#!/usr/bin/env bash

ROOT_DIR=$( cd $( dirname ${BASH_SOURCE:-$0} ) && pwd )

while getopts "w:p:e:f:" OPT
do
    case $OPT in
        e) OPT_ENV="$OPTARG";;
        p) OPT_PROJECT="$OPTARG" ;;
        w) OPT_LAMBDA="$OPTARG" ;;
        f) OPT_FUNCTION="$OPTARG" ;;
        h) help ;;
        *) exit ;;
    esac
done

shift $(( OPTIND - 1 ));

cd $ROOT_DIR

zip -r build/function.zip $OPT_LAMBDA/*

aws lambda update-function-code --function-name $(bash ./bin/output_stack.sh -p $OPT_PROJECT -e $OPT_ENV ${OPT_FUNCTION}Name) \
  --zip-file fileb://build/unction.zip 
