#!/bin/sh

# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
SCRIPTPATH=$( (cd "$(dirname "$0")" && pwd ))

echo "[INFO] CICD Pipeline for Apigee X/hybrid (Cloud Build)"
BRANCH_NAME_X=main
#SUBSTITUTIONS_X="_INT_TEST_HOST=$APIGEE_HOSTNAME"
SUBSTITUTIONS_X="_APIGEE_ORG=$APIGEE_ORG"
SUBSTITUTIONS_X="$SUBSTITUTIONS_X,_APIGEE_ENV=$APIGEE_ENV"
#SUBSTITUTIONS_X="$SUBSTITUTIONS_X,_API_VERSION=google"
SUBSTITUTIONS_X="$SUBSTITUTIONS_X,_WORK_DIR=."
#SUBSTITUTIONS_X="$SUBSTITUTIONS_X,BRANCH_NAME=$BRANCH_NAME_X"

export AUTH_TOKEN=$(gcloud auth print-access-token)
echo "Token was generated"

SUBSTITUTIONS_X="$SUBSTITUTIONS_X,_TOKEN=$AUTH_TOKEN"

echo $SUBSTITUTIONS_X
gcloud builds submit --config="$SCRIPTPATH/ci-config/cloudbuild/cloudbuild.yaml" --substitutions="$SUBSTITUTIONS_X"

