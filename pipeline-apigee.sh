set -e
SCRIPTPATH=$( (cd "$(dirname "$0")" && pwd ))

echo "[INFO] CICD Pipeline for Apigee X - TeamCity - Maven"


export TOKEN=$(gcloud auth print-access-token)
echo "Token was generated"
echo $TOKEN

mvn clean install -ntp \
          -P"googleapi" \
          -Denv="$APIGEE_ENV" \
          -Dtoken="$TOKEN" \
          -Dorg="$APIGEE_ORG" \
          -Ddeployment.suffix="-TeamCity" \
          -Ddeployment.description="GitHub-TeamCity"
