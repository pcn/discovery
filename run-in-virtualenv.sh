#!/bin/bash

cd /home/ubuntu/discovery
. /home/ubuntu/v/bin/activate

export HOST_TTL=10
export CACHE_TTL=30
export BACKEND_STORAGE=DynamoDB
export CACHE_TYPE=null
export APPLICATION_DIR=/root/discovery
export APPLICATION_ENV=vagrant
export DEBUG=true
export LOG_LEVEL=DEBUG
export PORT=17629
export DYNAMODB_TABLE_HOSTS=pcn-hosts-table
# DYNAMODB_URL
export DYNAMODB_CREATE_TABLES_IN_APP=true

python wsgi.py
