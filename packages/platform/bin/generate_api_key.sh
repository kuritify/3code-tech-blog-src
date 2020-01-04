#!/usr/bin/env bash

ROOT_DIR=$( cd $( dirname ${BASH_SOURCE:-$0} ) && pwd )

shift $(( OPTIND - 1 ));

head /dev/urandom | tr -dc A-Za-z0-9 | head -c 41 ; echo ''


