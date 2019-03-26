CHANGELOG
=========

## 2.1.1 - *3/25/2019*

- Updated the notice text when using environment variable `CRYPTR_PASSWORD` for the password.
- Updated `tests/test.bash`.
- Bump copyright year to 2019.

## 2.1.0 - *10/4/2017*

- You may now define the password to use when encrypting and decrypting using the `CRYPTR_PASSWORD` environment variable. This change enables non-interactive/batch operations.

- Added a test script `tests/test.bash`.

## 2.0.1 - *10/2/2017*

- Small optimization, removed unneeded function `cryptr_info()`.

## 2.0.0 - *10/2/2017*

*BREAKING CHANGE*
- Increased the OpenSSL key size to *256bit* from *128bit*. Any files encrypted with version `1.0.0` must be decrypted with version `1.0.0`. 

## 1.0.0 - *10/1/2017*

- Initial release.
