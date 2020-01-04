#!/usr/bin/env bash

ROOT_DIR=$( cd $( dirname ${BASH_SOURCE:-$0} ) && pwd )

cd $ROOT_DIR/../

echo ev.json | docker run --rm -v $(pwd)/orevia/src:/var/task -v $(pwd)/layer:/opt -i -e DOCKER_LAMBDA_USE_STDIN=1 lambci/lambda:nodejs8.10 app.lambdaHandler
