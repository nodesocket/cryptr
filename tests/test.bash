#!/usr/bin/env bash
set -eo pipefail; [[ $TRACE ]] && set -x

# Define color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Test counter
TOTAL_TESTS=2
CURRENT_TEST=0
FAILED_TESTS=0

# Function to display test progress
start_test() {
    ((CURRENT_TEST++))
    echo -e "\n${BLUE}Test ${CURRENT_TEST}/${TOTAL_TESTS}${NC} - ${BOLD}$1${NC}"
    echo -e "${YELLOW}$2${NC}"
}

# Function to display success
test_success() {
    echo -e "${GREEN}✓ Success:${NC} $1"
}

# Function to display error and exit
test_error() {
    echo -e "${RED}✗ Error:${NC} $1" 1>&2
    ((FAILED_TESTS++))
    exit "$2"
}

echo -e "\n${YELLOW}${BOLD}Running Cryptr Functional Tests${NC}\n"

# Set environment variables
export CRYPTR_PASSWORD
CRYPTR_PASSWORD=$(dd if=/dev/urandom bs=200 count=1 2> /dev/null | LC_ALL=C tr -dc 'A-Za-z0-9' | head -c32)

# Test 1: Single File Encryption/Decryption
start_test "Single File Encryption/Decryption" "Testing encryption and decryption of a single file..."

plaintext=$(mktemp /tmp/cryptr.XXXXXXXX)
dd if=/dev/urandom bs=4096 count=256 2> /dev/null | LC_ALL=C tr -dc 'A-Za-z0-9' | head -c262144 > "$plaintext"
plaintext_sha=($(openssl dgst -sha256 "$plaintext"))

echo -e "${BLUE}→${NC} Encrypting file..."
cryptr encrypt "$plaintext" || test_error "Failed to encrypt file" 3

if [[ ! -f "$plaintext".aes ]]; then
    test_error "Encrypted output file $plaintext.aes was not created" 3
fi
test_success "File encrypted successfully"

# Original file is already deleted by cryptr after answering 'y'

echo -e "${BLUE}→${NC} Decrypting file..."
cryptr decrypt "$plaintext".aes

decrypted_sha=($(openssl dgst -sha256 "$plaintext"))

rm -f "$plaintext".aes
rm -f "$plaintext"

if [ "${plaintext_sha[1]}" != "${decrypted_sha[1]}" ]; then
    test_error "Hash mismatch\n\t${plaintext_sha[1]} != ${decrypted_sha[1]}" 4
fi
test_success "File decrypted successfully with matching hash"

# Test 2: Directory Encryption/Decryption
start_test "Directory Encryption/Decryption" "Testing encryption and decryption of a directory..."

test_dir=$(mktemp -d /tmp/cryptr.XXXXXXXX)
test_file1="$test_dir/file1"
test_file2="$test_dir/file2"

echo -e "${BLUE}→${NC} Creating test files..."
dd if=/dev/urandom bs=4096 count=256 2> /dev/null | LC_ALL=C tr -dc 'A-Za-z0-9' | head -c262144 > "$test_file1"
dd if=/dev/urandom bs=4096 count=256 2> /dev/null | LC_ALL=C tr -dc 'A-Za-z0-9' | head -c262144 > "$test_file2"
test_success "Test files created"

dir_sha=($(find "$test_dir" -type f -exec openssl dgst -sha256 {} \; | sort | openssl dgst -sha256))

echo -e "${BLUE}→${NC} Encrypting directory..."
if [ ! -d "$test_dir" ]; then
    test_error "Test directory not found: $test_dir" 5
fi

# First create tar.gz
tar -czf "${test_dir}.tar.gz" -C "$(dirname "$test_dir")" "$(basename "$test_dir")"
test_success "Directory archived"

# Then encrypt the tar.gz
cryptr encrypt "${test_dir}.tar.gz" || test_error "Failed to encrypt directory archive" 5

if [[ ! -f "$test_dir".tar.gz.aes ]]; then
    test_error "Encrypted directory archive $test_dir.tar.gz.aes was not created" 5
fi
test_success "Directory encrypted successfully"

# Original directory will be deleted when answering 'y' to the prompt

echo -e "${BLUE}→${NC} Decrypting directory..."
cryptr decrypt "$test_dir".tar.gz.aes
test_success "Directory decrypted and extracted"

decrypted_dir_sha=($(find "$test_dir" -type f -exec openssl dgst -sha256 {} \; | sort | openssl dgst -sha256))

rm -rf "$test_dir"

if [ "${dir_sha[1]}" != "${decrypted_dir_sha[1]}" ]; then
    test_error "Directory hash mismatch\n\t${dir_sha[1]} != ${decrypted_dir_sha[1]}" 6
fi
test_success "Directory contents verified with matching hash"

# Print final summary
echo -e "\n${YELLOW}${BOLD}Test Summary${NC}"
if [ "$FAILED_TESTS" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}✓ All tests completed successfully!${NC}\n"
    exit 0
else
    echo -e "${RED}${BOLD}✗ Some tests failed!${NC}\n"
    exit 1
fi
