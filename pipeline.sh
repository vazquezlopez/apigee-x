set -e
SCRIPTPATH=$( (cd "$(dirname "$0")" && pwd ))

echo "[INFO] CICD Pipeline for Apigee X - TeamCity"
BRANCH_NAME_X=main

SUBSTITUTIONS_X="_DEPLOYMENT_ORG=$APIGEE_ORG"
SUBSTITUTIONS_X="$SUBSTITUTIONS_X,_APIGEE_TEST_ENV=$APIGEE_ENV"
SUBSTITUTIONS_X="$SUBSTITUTIONS_X,_API_VERSION=google"
SUBSTITUTIONS_X="$SUBSTITUTIONS_X,_WORK_DIR=."
SUBSTITUTIONS_X="$SUBSTITUTIONS_X,BRANCH_NAME=$BRANCH_NAME_X"

echo $SUBSTITUTIONS_X

echo "export APIGEE_BUILD_TOKEN=\"$(gcloud auth application-default print-access-token)\"" >> env.txt
cat env.txt
echo "[BUILD CONFIG] - Token generado"
echo "$APIGEE_BUILD_TOKEN"
sed "s/APIGEE_BUILD_TOKEN=.*/APIGEE_BUILD_TOKEN=[hidden]/g"

source env.txt && \
mvn clean install -ntp \
          -P"googleapi" \
          -Denv="$APIGEE_ENV" \
          -Dtoken="$${APIGEE_BUILD_TOKEN}" \
          -Dorg="$_DEPLOYMENT_ORG" \
          -Ddeployment.suffix="-TeamCity" \
          -Ddeployment.description="CloudRun Build: $BUILD_ID"

gcloud builds submit --config="$SCRIPTPATH/ci-config/cloudbuild/cloudbuild.yaml" \
  --substitutions="$SUBSTITUTIONS_X"
