#!/bin/bash
#
# Author: Fabio Fusaro
# email: fabio.fusaro@iit.it
#
# This script exports the cuda paths
#


FOLDER_PREFIX=~/git/hrii_gitlab/

CUDA_VERSION_LONG=`jq -r '.cuda|.version' /usr/local/cuda/version.json`
CUDA_VERSION=`cut -c 1-4 <<<"$CUDA_VERSION_LONG"`

export PATH="/usr/local/cuda-$CUDA_VERSION/bin${PATH:+:${PATH}}"
export LD_LIBRARY_PATH="/usr/local/cuda-$CUDA_VERSION/extras/CUPTI/lib64:/usr/local/cuda-$CUDA_VERSION/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"

echo "Sourced Cuda V$CUDA_VERSION. To switch version execute 'switch-cuda your_desired_version'"
