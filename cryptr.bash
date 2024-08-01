#!/usr/bin/env bash

###############################################################################
# Copyright 2024 Justin Keller
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################

set -eo pipefail; [[ $TRACE ]] && set -x

readonly VERSION="2.3.0"
readonly OPENSSL_CIPHER_TYPE="aes-256-cbc"

cryptr_version() {
  echo "cryptr $VERSION"
}

cryptr_help() {
  echo "Usage: cryptr command <command-specific-options>"
  echo
  cat<<EOF | column -c2 -t -s,
  encrypt <file|directory>, Encrypt file or directory
  decrypt <file.aes|directory.tar.gz.aes>, Decrypt encrypted file or directory
  help, Displays help
  version, Displays the current version
EOF
  echo
}

cryptr_encrypt() {
  local _path="$1"
  local _is_directory=0
  if [[ ! -e "$_path" ]]; then
    echo "File or directory not found" 1>&2
    exit 4
  fi

  if [[ -d "$_path" ]]; then
    tar -czf "${_path}.tar.gz" -C "$(dirname "$_path")" "$(basename "$_path")"
    _path="${_path}.tar.gz"
    _is_directory=1
  fi

  if [[ ! -z "${CRYPTR_PASSWORD}" ]]; then
    echo "[notice] using environment variable CRYPTR_PASSWORD for the password"
    openssl $OPENSSL_CIPHER_TYPE -salt -pbkdf2 -in "$_path" -out "${_path}.aes" -pass env:CRYPTR_PASSWORD
  else
    openssl $OPENSSL_CIPHER_TYPE -salt -pbkdf2 -in "$_path" -out "${_path}.aes"
  fi

  if [[ $? -eq 0 ]]; then
    if [[ $_is_directory -eq 1 ]]; then
      rm -f "$_path"
    fi

    if [[ $_is_directory -eq 1 ]]; then
      read -p "do you want to delete the original directory? (y/N): " confirm
      if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo "[notice] deleting the original directory"
        rm -rf "${_path%.tar.gz}"
      fi
    else

      read -p "do you want to delete the original file? (y/N): " confirm
      if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo "[notice] deleting the original file"
        rm -f "$_path"
      fi
    fi
  else
    echo "[error] encryption failed, original file/directory not deleted" 1>&2
    exit 6
  fi
}

cryptr_decrypt() {
  local _file="$1"
  if [[ ! -f "$_file" ]]; then
    echo "File not found" 1>&2
    exit 5
  fi

  if [[ ! -z "${CRYPTR_PASSWORD}" ]]; then
    echo "[notice] using environment variable CRYPTR_PASSWORD for the password"
    openssl $OPENSSL_CIPHER_TYPE -d -salt -pbkdf2 -in "$_file" -out "${_file%\.aes}" -pass env:CRYPTR_PASSWORD
  else
    openssl $OPENSSL_CIPHER_TYPE -d -salt -pbkdf2 -in "$_file" -out "${_file%\.aes}"
  fi

  if [[ "${_file%\.aes}" == *.tar.gz ]]; then
    read -p "Do you want to extract the decrypted archive? (y/N): " extract_confirm
    if [[ "$extract_confirm" =~ ^[Yy]$ ]]; then
      tar -xzf "${_file%\.aes}" -C "$(dirname "${_file%\.aes}")"
      echo "[notice] archive extracted"

      read -p "Do you want to delete the decrypted tar.gz file? (y/N): " delete_confirm
      if [[ "$delete_confirm" =~ ^[Yy]$ ]]; then
        rm -f "${_file%\.aes}"
        echo "[notice] decrypted tar.gz file deleted"
      fi
    fi
  fi
}

cryptr_main() {
  local _command="$1"

  if [[ -z $_command ]]; then
    cryptr_version
    echo
    cryptr_help
    exit 0
  fi

  shift 1
  case "$_command" in
    "encrypt")
      cryptr_encrypt "$@"
      ;;

    "decrypt")
      cryptr_decrypt "$@"
      ;;

    "version")
      cryptr_version
      ;;

    "help")
      cryptr_help
      ;;

    *)
      cryptr_help 1>&2
      exit 3
  esac
}

if [[ "$0" == "$BASH_SOURCE" ]]; then
  cryptr_main "$@"
fi