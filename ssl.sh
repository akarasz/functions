#!/bin/bash

download-https-cert() {
    local fqdn="$1"

     openssl s_client -connect ${fqdn}:443 -showcerts </dev/null | openssl x509 -outform PEM >${fqdn}.pem
}

add-cert-to-keystore() {
    local certfile="$1"

    sudo cp $certfile /etc/ssl/certs
    sudo update-ca-certificates
}

add-cert-to-java-keystore() {
    local certfile="$1"

    echo "THE KEYSTORE PASSWORD SHOULD BE changeit"
    sudo keytool -import -alias $(basename $certfile .pem) -keystore $JAVA_HOME/jre/lib/security/cacerts -file $certfile
}
