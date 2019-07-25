# Create an OSEv3 group that contains the masters, nodes, and etcd groups
[OSEv3:children]
masters
nodes
etcd

# Set variables common for all OSEv3 hosts
[OSEv3:vars]
ansible_ssh_user=root
ansible_become=yes
openshift_deployment_type=origin

openshift_master_cluster_hostname=${master_public_dns}
openshift_master_cluster_public_hostname=${master_public_dns}

# using htpassword authentication on master
openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider'}]

# disable memory checks on the EC2 host
openshift_disable_check=memory_availability,disk_availability


openshift_cloudprovider_kind=aws
openshift_cloudprovider_aws_access_key=${replace_aws_access}
openshift_cloudprovider_aws_secret_key=${replace_aws_secrets}
openshift_clusterid=OKD-3.11

# host group for masters

[masters]
${master_private_dns}
# host group for etcd

[etcd]
${master_private_dns}

# host group for nodes, includes role info

[nodes]
${master_private_dns} openshift_node_group_name='node-config-master-infra'
${node_private_dns} openshift_node_group_name='node-config-compute'
