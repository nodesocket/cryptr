#!/usr/bin/env bash
set -eo pipefail; [[ $TRACE ]] && set -x

plaintext=$(mktemp /tmp/cryptr.XXXXXXXX)
dd if=/dev/urandom bs=1024 count=1 2> /dev/null | LC_ALL=C tr -dc 'A-Za-z0-9' | head -c200 > "$plaintext"
plaintext_sha=$(shasum -a 256 "$plaintext")

cryptr encrypt "$plaintext"
rm -f "$plaintext"
cryptr decrypt "$plaintext".aes

decrypted_sha=$(shasum -a 256 "$plaintext")

echo "$plaintext_sha"
echo "$decrypted_sha"
