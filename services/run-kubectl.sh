#!/bin/bash

if [ -z ${AWS_ACCESS_KEY_ID+x} ] && [ -z ${AWS_SECRET_ACCESS_KEY+x} ] ; then
    echo "Kubectl user is not enrolled, due to unset AWS_ACCESS_KEY_ID and/or AWS_SECRET_ACCESS_KEY"
else
    aws s3api get-object --bucket $S3_BUCKET --key $S3_KEY.tar.gz $S3_KEY.tar.gz
    tar zxvf $S3_KEY.tar.gz
    cd $USER_NAME

    echo Cluster name: $CLUSTER_NAME
    echo Master elb: $MASTER_LOAD_BALANCER

    CA_CRT=ca.pem
    USER_KEY=$USER_NAME-key.pem
    USER_CSR=$USER_NAME.csr
    USER_CRT=$USER_NAME.cert

    kubectl config set-cluster $CLUSTER_NAME-cluster --server=https://$MASTER_LOAD_BALANCER --certificate-authority=$CA_CRT
    kubectl config set-credentials $USER_NAME --certificate-authority=$CA_CRT --client-key=$USER_KEY --client-certificate=$USER_CRT
    kubectl config set-context $CLUSTER_NAME-context --cluster=$CLUSTER_NAME-cluster --user=$USER_NAME
    kubectl config use-context $CLUSTER_NAME-context

    cd ..
    rm -rf zxvf $S3_KEY.tar.gz
    echo "Kubectl user enrolled!"
fi
