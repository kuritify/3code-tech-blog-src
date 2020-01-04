#!/usr/bin/env bash

ROOT_DIR=$( cd $( dirname ${BASH_SOURCE:-$0} ) && pwd )

help() {
    cat << HELP
 Usage: $0 -s <stack-name> <output_name>

 Options
    -h                show this help
    -p                project name
    -s                stack name
HELP
    exit 0
}

while getopts "s:h" OPT
do
    case $OPT in
        s) OPT_STACK="$OPTARG";;
        h) help ;;
        *) exit ;;
    esac
done

shift $(( OPTIND - 1 ));

[ -z "$OPT_STACK" ] && help

ARG=$1

cd $ROOT_DIR
set -euo pipefail

if [ -z "$ARG" ]
then
  aws cloudformation describe-stacks --stack-name $OPT_STACK \
      --query "Stacks[0].Outputs" \
      --output text
else
  aws cloudformation describe-stacks --stack-name $OPT_STACK \
      --query "Stacks[0].Outputs[?OutputKey==\`$ARG\`].OutputValue" \
      --output text
fi
