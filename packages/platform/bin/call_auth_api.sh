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
set -eu

#SESSION=$(aws cognito-idp admin-initiate-auth \
#  --user-pool-id $(output_stack.sh -e $OPT_ENV -p $OPT_PROJECT CognitoPoolId) \
#  --client-id $(bash output_stack.sh -e $OPT_ENV -p $OPT_PROJECT CognitoClientId) \
#  --auth-flow ADMIN_NO_SRP_AUTH \
#  --auth-parameters USERNAME=skuri,PASSWORD=1Qazxsw@ | jq -r .Session)

#aws cognito-idp admin-respond-to-auth-challenge \
#  --user-pool-id $(bash output_stack.sh -e $OPT_ENV -p $OPT_PROJECT CognitoPoolId) \
#  --client-id $(output_stack.sh -e $OPT_ENV -p $OPT_PROJECT CognitoClientId) \
#  --challenge-name NEW_PASSWORD_REQUIRED --challenge-responses USERNAME=skuri,NEW_PASSWORD=1Qazxsw@3 --session ${SESSION}

SESSION=$(aws cognito-idp admin-initiate-auth \
  --user-pool-id $(output_stack.sh -e $OPT_ENV -p $OPT_PROJECT CognitoPoolId) \
  --client-id $(output_stack.sh -e $OPT_ENV -p $OPT_PROJECT CognitoClientId) \
  --auth-flow ADMIN_NO_SRP_AUTH \
  --auth-parameters USERNAME=skuri,PASSWORD=1Qazxsw@3 | jq -r .AuthenticationResult.IdToken)

curl -H "Authorization: Bearer $SESSION" $(output_stack.sh -e $OPT_ENV -p $OPT_PROJECT ApiGatewayEndpoint)/v1/users/any --verbose
