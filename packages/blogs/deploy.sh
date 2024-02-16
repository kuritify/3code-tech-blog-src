#!/usr/bin/env bash

ROOT_DIR=$( cd $( dirname ${BASH_SOURCE:-$0} ) && pwd )

help() {
    cat << HELP
 Usage: $0 [options...] <arg>

 Options
    -h                show this help
    -c                with clear cache
HELP
    exit 0
}

while getopts "ch" OPT
do
    case $OPT in
        c) OPT_CACHE_CLEAR="1" ;;
        h) help ;;
        *) exit ;;
    esac
done

shift $(( OPTIND - 1 ));


cd $ROOT_DIR

yarn docs:build

aws s3 rm s3://tech-blog.3code.dev/ --recursive
aws s3 cp --recursive ./dist/ s3://tech-blog.3code.dev

if [ -n "$OPT_CACHE_CLEAR" ]
then
  aws cloudfront create-invalidation --distribution-id E3T1EJO734TZOV  --paths "/*"
fi
