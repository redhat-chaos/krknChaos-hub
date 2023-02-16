#!/bin/bash

# Vars and respective defaults
export CERBERUS_ENABLED=${CERBERUS_ENABLED:=False}
export CERBERUS_URL=${CERBERUS_URL:=http://0.0.0.0:8080}
export KRKN_KUBE_CONFIG=${KRKN_KUBE_CONFIG:=/root/.kube/config}
export WAIT_DURATION=${WAIT_DURATION:=60}
export ITERATIONS=${ITERATIONS:=1}
export DAEMON_MODE=${DAEMON_MODE:=False}
export RETRY_WAIT=${RETRY_WAIT:=120}
export PUBLISH_KRAKEN_STATUS=${PUBLISH_KRAKEN_STATUS:=False}
export SIGNAL_ADDRESS=${SIGNAL_ADDRESS:=0.0.0.0}
export PORT=${PORT:=8081}
export LITMUS_VERSION=${LITMUS_VERSION:=v1.13.8}
export SIGNAL_STATE=${SIGNAL_STATE:=RUN}
export DEPLOY_DASHBOARDS=${DEPLOY_DASHBOARDS:=False}
export CAPTURE_METRICS=${CAPTURE_METRICS:=False}
export ENABLE_ALERTS=${ENABLE_ALERTS:=False}
export ES_SERVER=${ES_SERVER:=http://0.0.0.0:9200}

# Unset KUBECONFIG to make sure mounted kubeconfig is used
unset KUBECONFIG
