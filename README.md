# cryptr

#### An enhanced shell utility for encrypting and decrypting files and directories using OpenSSL.

This is a fork of [cryptr](https://github.com/nodesocket/cryptr) by Justin Keller, with added support for directory encryption.

## Installation

```
git clone https://github.com/Gu1llaum-3/cryptr.git
ln -s "$PWD"/cryptr/cryptr.bash /usr/local/bin/cryptr
```

### Shell Completion

cryptr supports command completion for both Bash and Zsh shells.

#### Bash Completion

There are two ways to enable bash completion:

1. **Temporary (current session):**
```bash
source tools/cryptr-bash-completion.bash
```

2. **Permanent:**
```bash
# Create completion directory if needed
mkdir -p ~/.bash_completion.d/
# Copy completion file
cp tools/cryptr-bash-completion.bash ~/.bash_completion.d/
# Add to ~/.bashrc or ~/.bash_profile
echo 'source ~/.bash_completion.d/cryptr-bash-completion.bash' >> ~/.bashrc
```

#### Zsh Completion

Similarly for zsh:

1. **Temporary (current session):**
```zsh
source tools/cryptr-zsh-completion.zsh
```

2. **Permanent:**
```zsh
# Create zsh directory if needed
mkdir -p ~/.zsh
# Copy completion file
cp tools/cryptr-zsh-completion.zsh ~/.zsh/
# Add to ~/.zshrc
echo 'source ~/.zsh/cryptr-zsh-completion.zsh' >> ~/.zshrc
```

After enabling completion, you can use:
- TAB after 'cryptr' to see available commands (encrypt, decrypt, help, version)
- TAB after 'encrypt' to see all files and directories
- TAB after 'decrypt' to see only .aes encrypted files

## API/Commands

### encrypt

> encrypt \<file|directory\> - Encrypts file or directory with OpenSSL AES-256 cipher block chaining. For files, writes an encrypted file out *(ciphertext)* appending `.aes` extension. For directories, creates a tar.gz archive first, then encrypts it with `.tar.gz.aes` extension.

```
➜ cryptr encrypt ./secret-file
enter aes-256-cbc encryption password:
Verifying - enter aes-256-cbc encryption password:
```

```
➜ cryptr encrypt ./secret-directory
enter aes-256-cbc encryption password:
Verifying - enter aes-256-cbc encryption password:
```

You may optionally define the password to use when encrypting using the `CRYPTR_PASSWORD` environment variable. This enables non-interactive/batch operations.

```
➜ CRYPTR_PASSWORD=A1EO7S9SsQYcPChOr47n cryptr encrypt ./secret-file
```

### decrypt

> decrypt \<file.aes|directory.tar.gz.aes\> - Decrypt encrypted file or directory using OpenSSL AES-256 cipher block chaining. For files, writes a decrypted file out *(plaintext)* removing `.aes` extension. For directories, removes `.aes` extension and optionally extracts the tar.gz archive.

```
➜ cryptr decrypt ./secret-file.aes
enter aes-256-cbc decryption password:
```

```
➜ cryptr decrypt ./secret-directory.tar.gz.aes
enter aes-256-cbc decryption password:
Do you want to extract the decrypted archive? (y/N): y
```

You may optionally define the password to use when decrypting using the `CRYPTR_PASSWORD` environment variable. This enables non-interactive/batch operations.

```
➜ CRYPTR_PASSWORD=A1EO7S9SsQYcPChOr47n cryptr decrypt ./secret-file.aes
```

### help

> help - Displays help

```
➜ cryptr help
Usage: cryptr command <command-specific-options>

  encrypt <file|directory>       Encrypt file or directory
  decrypt <file.aes|directory.tar.gz.aes>   Decrypt encrypted file or directory
  help                 Displays help
  version              Displays the current version
```

### version

> version - Displays the current version

```
➜ cryptr version
cryptr 3.0.0
```

## Changelog

See CHANGELOG.md

## Support, Bugs, And Feature Requests

Create issues here in GitHub (https://github.com/Gu1llaum-3/cryptr/issues).

## Versioning

For transparency and insight into the release cycle, and for striving to maintain backward compatibility, cryptr will be maintained under the semantic versioning guidelines.

Releases will be numbered with the follow format:

`<major>.<minor>.<patch>`

And constructed with the following guidelines:

+ Breaking backward compatibility bumps the major (and resets the minor and patch)
+ New additions without breaking backward compatibility bumps the minor (and resets the patch)
+ Bug fixes and misc changes bumps the patch

For more information on semantic versioning, visit http://semver.org/.

## License & Legal

Copyright 2024 Guillaume Archambault
Based on cryptr by Justin Keller

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
