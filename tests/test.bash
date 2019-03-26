#!/usr/bin/env bash
set -eo pipefail; [[ $TRACE ]] && set -x

plaintext=$(mktemp /tmp/cryptr.XXXXXXXX)
dd if=/dev/urandom bs=4096 count=256 2> /dev/null | LC_ALL=C tr -dc 'A-Za-z0-9' | head -c262144 > "$plaintext"
plaintext_sha=($(openssl dgst -sha256 "$plaintext"))

export CRYPTR_PASSWORD
CRYPTR_PASSWORD=$(dd if=/dev/urandom bs=200 count=1 2> /dev/null | LC_ALL=C tr -dc 'A-Za-z0-9' | head -c32)

cryptr encrypt "$plaintext"
rm -f "$plaintext"

if [[ ! -f "$plaintext".aes ]]; then
    printf "Encrypted out file %s was not created" "$plaintext".aes 1>&2
    exit 3
fi

cryptr decrypt "$plaintext".aes

decrypted_sha=($(openssl dgst -sha256 "$plaintext"))

rm -f "$plaintext".aes
rm -f "$plaintext"

if [ "${plaintext_sha[1]}" != "${decrypted_sha[1]}" ]; then
    printf "Hash mismatch\n\t%s != %s" "${plaintext_sha[1]}" "${decrypted_sha[1]}" 1>&2
    exit 4
fi
