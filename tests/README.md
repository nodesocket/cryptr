# Testing cryptr

The test suite verifies both file and directory encryption/decryption functionality.

## Running Tests

```bash
# Make the test script executable
chmod +x test.bash

# Run the tests
./test.bash
```

## What is Tested

The test script performs the following checks:

1. File encryption/decryption:
   - Creates a random test file
   - Encrypts it using cryptr
   - Verifies the encrypted file exists
   - Decrypts the file
   - Verifies data integrity using SHA-256 hash

2. Directory encryption/decryption:
   - Creates a test directory with multiple random files
   - Encrypts the directory using cryptr
   - Verifies the encrypted archive exists
   - Decrypts and extracts the directory
   - Verifies directory contents integrity using SHA-256 hashes

All temporary files and directories are automatically cleaned up after testing.
