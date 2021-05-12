#!/bin/bash -xe
set +o pipefail

export csv_version=`yq .channels[0].currentCSV upstream-community-operators/ibm-block-csi-operator-community/ibm-block-csi-operator.package.yaml`
export csv_version=`echo ${csv_version//ibm-block-csi-operator.v}`
export csv_version=`echo ${csv_version//\"}`
export csv_file=~/work/$CI_REPOSITORY_NAME/$CI_REPOSITORY_NAME/upstream-community-operators/ibm-block-csi-operator-community/$csv_version/ibm-block-csi-operator.v$csv_version.clusterserviceversion.yaml
export k8s_version='v'`yq .spec.minKubeVersion $csv_file`
export k8s_version=`echo ${k8s_version//\"}`
export wanted_image=$operator_image
export current_image=`yq .metadata.annotations.containerImage $csv_file`
export current_image=`echo ${current_image//\"}`
export community_operators_path=community-operators/ibm-block-csi-operator-community/$csv_version

sed -i "s+$current_image+$wanted_image+g" $csv_file

echo '::set-output name=community_operators_path::$community_operators_path'
