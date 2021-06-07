#!/bin/sh
set -e

cd /tmp
# https://www.openssl.org/docs/man1.1.0/man3/OpenSSL_add_all_algorithms.html
sed -ie '/OpenSSL_add_all_algorithms/d' regress/unittests/sshsig/tests.c
TEST_SSH_UNSAFE_PERMISSIONS=1 \
  make file-tests interop-tests unit SK_DUMMY_LIBRARY=''
