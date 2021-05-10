#!/bin/bash -xe
set +o pipefail

export wanted_image=ibmcom/ibm-block-csi-operator:1.6.0
export csv_file=~/work/$CI_REPOSITORY_NAME/$CI_REPOSITORY_NAME/upstream-community-operators/ibm-block-csi-operator-community/1.5.0/ibm-block-csi-operator.v1.5.0.clusterserviceversion.yaml
export current_image=`yq .metadata.annotations.containerImage $csv_file`
export current_image=`echo ${current_image//\"}`

sed -i "s+$current_image+$wanted_image+g" $csv_file

echo Reseting kind cluster
ansible-pull -U https://github.com/operator-framework/operator-test-playbooks -C master -i localhost, -e ansible_connection=local -e run_upstream=true -e run_remove_catalog_repo=false upstream/local.yml -e run_prepare_catalog_repo_upstream=false --tags reset

echo Running test
docker run -d -i -e ANSIBLE_CONFIG=/playbooks/upstream/ansible.cfg -e GODEBUG=x509ignoreCN=0 --name op-test --privileged --net host -v ~/.optest/certs:/usr/share/pki/ca-trust-source/anchors -e STORAGE_DRIVER=vfs -e BUILDAH_FORMAT=docker -v ~/work/$CI_REPOSITORY_NAME/$CI_REPOSITORY_NAME:/tmp/community-operators-for-catalog quay.io/operator_testing/operator-test-playbooks:latest
docker cp ~/.kube/ op-test:/root/
docker exec -i -e ANSIBLE_CONFIG=/playbooks/upstream/ansible.cfg -e GODEBUG=x509ignoreCN=0 op-test /bin/bash -c 'update-ca-trust && ansible-playbook -i localhost, -e ansible_connection=local upstream/local.yml -e run_upstream=true -e image_protocol='\''docker://'\'' -vv -e container_tool=podman -e run_prepare_catalog_repo_upstream=false -e operator_dir=/tmp/community-operators-for-catalog/upstream-community-operators/ibm-block-csi-operator-community -e operator_version=1.5.0 --tags pure_test -e operator_channel_force=optest -e strict_mode=true -e opm_index_add_mode=replaces'