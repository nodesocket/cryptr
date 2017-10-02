# cryptr

##### A simple shell utility for encrypting and decrypting files.

## Installation

```
git clone https://github.com/nodesocket/cryptr.git
ln -s "$PWD"/cryptr/cryptr.bash /usr/local/bin/cryptr
```

## API/Commands

### encrypt

> encrypt \<file\> - Encryptes file with OpenSSL AES-128 cipher block chaining. Writes an encrypted file out *(ciphertext)* appending `.aes` extension.

```
➜ cryptr encrypt ./secrets-file
enter aes-128-cbc encryption password:
Verifying - enter aes-128-cbc encryption password:
```

```
➜ ls -alh
-rw-r--r--  1 user  group   1.0G Oct  1 13:33 secrets-file
-rw-r--r--  1 user  group   1.0G Oct  1 13:34 secrets-file.aes
```


### decrypt

> decrypt \<file.aes\> - Decrypt encrypted file using OpenSSL AES-128 cipher block chaining. Writes a decrypted file out *(plaintext)* removing `.aes` extension.

```
➜ ls -alh
-rw-r--r--  1 user  group   1.0G Oct  1 13:34 secrets-file.aes
```

```
➜ cryptr decrypt ./secrets-file.aes
enter aes-128-cbc decryption password:
```

```
➜ ls -alh
-rw-r--r--  1 user  group   1.0G Oct  1 13:35 secrets-file
-rw-r--r--  1 user  group   1.0G Oct  1 13:34 secrets-file.aes
```

### help

> help - Displays help

```
➜ cryptr help
Usage: cryptr command <command-specific-options>

  encrypt <file>       Encrypt file
  decrypt <file.aes>   Decrypt encrypted file
  help                 Displays help
  version              Displays the current version

```

### version

> version - Displays the current version

```
➜ cryptr version
cryptr 1.0.0
```

### default

> default - Displays the current version and help

```
➜ cryptr
cryptr 1.0.0

Usage: cryptr command <command-specific-options>

  encrypt <file>       Encrypt file
  decrypt <file.aes>   Decrypt encrypted file
  help                 Displays help
  version              Displays the current version

```

## Changelog

https://github.com/nodesocket/cryptr/blob/master/CHANGELOG.md

## Support, Bugs, And Feature Requests

Create issues here in GitHub (https://github.com/nodesocket/cryptr/issues).

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

Copyright 2017 Justin Keller

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
