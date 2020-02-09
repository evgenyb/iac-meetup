#!/usr/bin/env bash

sudo certbot certonly --manual --preferred-challenges=dns --email admin@ifoobar.no --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d *.ifoobar.no

# pem to pfx
sudo openssl pkcs12 -inkey privkey1.pem -in cert1.pem -export -out start-ifooobar-no.pfx
