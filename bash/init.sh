cat ~/.kube/config | base64 -w 0 | gh secret set CONFIG
YC_CLI_INITIALIZATION_SILENCE=true yc container registry list --format json | jq -r '.[] | select(.name == "cr--application") | .id' | gh secret set REG_ID

YC_CLI_INITIALIZATION_SILENCE=true yc iam key create --service-account-name "sa--terraform" --output iam_key.json
kubectl create secret docker-registry cr--credentials \
  --docker-server=cr.yandex \
  --docker-username=json_key \
  --docker-password="$(cat iam_key.json)"

gh workflow run apply-manifests.yml -f image_tag=latest --ref main
