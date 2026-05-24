```bash
gh secret set CONFIG # cat ~/.kube/config | base64 -w 0
gh secret set REG_ID # yc container registry list

yc iam key create --service-account-name "sa--terraform" --output iam_key.json

kubectl create secret docker-registry cr--credentials \
  --docker-server=cr.yandex \
  --docker-username=json_key \
  --docker-password="$(cat iam_key.json)"
```