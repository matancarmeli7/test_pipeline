#!/bin/bash -xe
set +o pipefail

sed -i "s+$current_image+$wanted_image+g" $csv_file