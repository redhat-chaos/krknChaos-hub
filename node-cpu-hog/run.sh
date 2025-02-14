#!/bin/bash

ROOT_FOLDER="/home/krkn"
KRAKEN_FOLDER="$ROOT_FOLDER/kraken"
SCENARIO_FOLDER="$KRAKEN_FOLDER/scenarios/kube"

# Source env.sh to read all the vars
source $ROOT_FOLDER/main_env.sh
source $ROOT_FOLDER/env.sh
source $ROOT_FOLDER/common_run.sh

if [[ $KRKN_DEBUG == "True" ]];then
  set -ex
fi

envsubst < $KRAKEN_FOLDER/scenarios/kube/cpu-hog.yml.template > $KRAKEN_FOLDER/scenarios/kube/cpu-hog.yml

cat $KRAKEN_FOLDER/scenarios/kube/cpu-hog.yml
# Substitute config with environment vars defined
envsubst < $KRAKEN_FOLDER/config/config.yaml.template > $KRAKEN_FOLDER/config/cpu_config.yaml

checks

# Run Kraken
cd $KRAKEN_FOLDER

if [[ $KRKN_DEBUG == "True" ]];then
  cat scenarios/kube/cpu-hog.yml
  cat config/cpu_config.yaml
fi

python3.9 run_kraken.py --config=config/cpu_config.yaml


