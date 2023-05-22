#!/bin/bash

# Logging format
log() {
  echo -e "\033[1m$(date "+%d-%m-%YT%H:%M:%S") ${*}\033[0m"
}

# Check if oc is installed
check_oc() {
  log "Checking if OpenShift client is installed"
  if ! which oc;
  then
    log "Looks like OpenShift client is not installed, please install before continuing"
    log "Exiting"
    exit 1
  fi
}

# Check if kubectl is installed
check_kubectl() {
  log "Checking if kubernetes client is installed"
  if ! which kubectl;
  then
    log "Looks like Kubernetes client is not installed, please install before continuing"
    log "Exiting"
    exit 1
  fi
}

# Check if cluster exists and print the clusterversion under test
check_cluster_version() {
  if ! kubectl version;
  then 
    log "Unable to connect to the cluster, please check if it's up and make sure the KUBECONFIG is set correctly"
    exit 1
  fi
  kubectl get clusterversion || log "Not an OpenShift environment"
}


checks() {
  check_oc
  check_kubectl
  check_cluster_version
}

# Config substitutions
config_setup(){
  envsubst < /root/kraken/config/kube_burner.yaml.template > /root/kraken/config/kube_burner.yaml
}

setup_arcaflow_env(){
    # will create the arcaflow input.yaml replacing the env variables
    # and creating an input_list entry per each node selector passed as
    # NODE_SELECTORS env

    # check for yq in $PATH
    YQ=`which yq`
    [ -z $YQ ] && echo "Error: yq not found in PATH" && exit 1

    # blank the default input file
    echo > $1/input.yaml
    
    IFS=';' read -r -a SELECTORS <<< $NODE_SELECTORS
    if [[ "${#SELECTORS[@]}" > 0 ]]
    then
        for selector in "${SELECTORS[@]}"
        do
            [[ ! $selector =~ ^.+\=.+ ]] && echo "$selector is not in the right format, node selectors must be in the format <selector>=<value>" && exit 1
            IFS='=' read -r -a SPLITTED_SELECTOR <<< $selector
            export SELECTOR=${SPLITTED_SELECTOR[0]}
            export SELECTOR_VALUE=${SPLITTED_SELECTOR[1]}
            export TEMPLATE=`envsubst < $1/input.yaml.template`
            $YQ e '.input_list += [env(TEMPLATE)]' -i $1/input.yaml
            
        done
    else
          export SELECTOR="none"
          export SELECTOR_VALUE="none"
          export TEMPLATE=`envsubst < $1/input.yaml.template`
          TEMPLATE=`echo "${TEMPLATE}" | yq e '.node_selector={}'`
          $YQ e '.input_list += [env(TEMPLATE)]' -i $1/input.yaml
    fi
}

