#!/bin/bash
set -e

TAG=$(git rev-parse --short HEAD)

YELLOW='\033[1;33m'
NC='\033[0m' # No Color

#BUILD
docker build -t asamerh4/python-fmask:fmask0.4-aws-$TAG .

echo -e ${YELLOW}"**build finished -> use: docker run --rm --memory=12g --memory-swap=12g -e inputId=s3://s2-sync/tiles/33/X/WH/2016/9/9/1/ -e outputId=s3://s2-derived/tiles/33/X/WH/2016/9/9/1/ -e AWS_DEFAULT_REGION=eu-central-1 -it asamerh4/python-fmask:fmask0.4-aws-$TAG ./run-fmask.sh" ${NC}