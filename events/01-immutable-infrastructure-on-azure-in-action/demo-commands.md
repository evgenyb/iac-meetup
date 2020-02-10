iac
cd infra/scripts/demo/
http://iac-dev-agw-pip.westeurope.cloudapp.azure.com/api/values
./01-init-dns.sh
nslookup iac-dev.ifoobar.no
watch -n 0.1 'curl -s http://iac-dev.ifoobar.no/api/values'
./02-add-tfm.sh
./03-set-tfm-dns.sh
nslookup iac-dev.ifoobar.no
http://iac-dev-blue-agw-pip.westeurope.cloudapp.azure.com/api/values
./04-add-blue-endpoint.sh
./05-enable-blue-50-percent.sh
./06-set-blue-100-percent.sh

http://iac-dev-green-apim.azure-api.net/api/health/ready
http://iac-dev-green-apim.azure-api.net/api/values

./07-add-green-endpoint.sh
./08-enable-green-50-percent.sh
./09-set-green-100-percent.sh