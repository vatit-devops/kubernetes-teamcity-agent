#!/bin/bash

if [ -z ${AWS_ACCESS_KEY_ID+x} && -z ${AWS_SECRET_ACCESS_KEY+x} ] ; then
    echo "Kubectl is not enrolled, due to unset AWS_ACCESS_KEY_ID and/or AWS_SECRET_ACCESS_KEY"
else
    cd /
    ./kube_tc_build-enroll.sh
    echo "Kubectl user enrolled!"
fi