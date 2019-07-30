#!/bin/bash
aws s3 cp s3://okd-cluster-state/config ./config
wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
tar -xf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc apply -f k8s-deploy/nfs/00namespace.yaml --kubeconfig ./config
openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc apply -f k8s-deploy/nfs-scc.yaml --kubeconfig ./config
openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc apply -f k8s-deploy/nfs/02ServiceAccount.yaml --kubeconfig ./config
openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc adm policy add-scc-to-user nfs-provisioner system:serviceaccount:hero-flow:nfs-server-provisioner --kubeconfig ./config
openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc apply -f k8s-deploy/mongodb --kubeconfig ./config -n hero-flow
if [ "${Deploy_First_Time_Services}" = 'true' ]; then {
i=`openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc get sts -nhero-flow mongodb-replicaset  --kubeconfig ./config | awk 'FNR>1 {print $3}'`
while [ "${i}" -ge 1 ]
do
    i=`openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc get sts -nhero-flow mongodb-replicaset  --kubeconfig ./config | awk 'FNR>1 {print $3}'`
    echo "Mongo DB is creating"
done
openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc apply -f k8s-deploy/db-setup.yaml -n hero-flow  --kubeconfig ./config 
openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc create secret docker-registry saleshero-registry-secret --docker-username=rzwodzwo --docker-password=8YTOqtGswl@h0vJs2wrgyGX7 --docker-email=r2d2@automationhero.ai -nhero-flow  --kubeconfig ./config 
} fi
openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc patch sa default -p '"imagePullSecrets": [{"name": "saleshero-registry-secret" }]'  -nhero-flow --kubeconfig ./config
openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc apply -f k8s-deploy/nfs --kubeconfig ./config -n hero-flow
openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc apply -f k8s-deploy/app-pvc.yaml --kubeconfig ./config -n hero-flow
openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc apply -f k8s-deploy/admin.yaml --kubeconfig ./config -n hero-flow
openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc adm policy add-scc-to-user privileged -nhero-flow -z admin-sa  --kubeconfig ./config
openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc apply -f k8s-deploy/nodes.yaml --kubeconfig ./config -n hero-flow
