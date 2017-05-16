CLUSTER_NAME=default
USERNAME=kube_tc_build
MASTER_LOAD_BALANCER=master-load-balancer-1423288533.eu-west-1.elb.amazonaws.com

aws s3api get-object --bucket kubernetes-user-keys --key kube-credentials-$USERNAME-$CLUSTER_NAME.tar.gz kube-credentials-$USERNAME-$CLUSTER_NAME.tar.gz
tar zxvf kube-credentials-$USERNAME-$CLUSTER_NAME.tar.gz
cd $USERNAME

echo Cluster name: $CLUSTER_NAME
echo Master elb  : $MASTER_LOAD_BALANCER

CA_CRT=ca.pem
USER_KEY=$USERNAME-key.pem
USER_CSR=$USERNAME.csr
USER_CRT=$USERNAME.cert

kubectl config set-cluster $CLUSTER_NAME-cluster --server=https://$MASTER_LOAD_BALANCER --certificate-authority=$CA_CRT
kubectl config set-credentials $USERNAME --certificate-authority=$CA_CRT --client-key=$USER_KEY --client-certificate=$USER_CRT
kubectl config set-context $CLUSTER_NAME-context --cluster=$CLUSTER_NAME-cluster --user=$USERNAME
kubectl config use-context $CLUSTER_NAME-context

cd ..
rm -rf zxvf kube-credentials-$USERNAME-$CLUSTER_NAME.tar.gz
