#!/bin/bash
set -e

echo "# about defaults"

makefile=$(cat <<'eom'
include localcert.mk
eom
)

echo "## creates a keystore named after the cwd"
testdir=$(mktemp -d)
cp localcert.mk "$testdir"
proj=$(echo "$testdir" | rev | cut -d / -f 1 | rev)
keystore="${proj}-localhost.jks"
echo "$makefile" > "${testdir}/Makefile" && make -s -C "$testdir" "$keystore"
[[ -f "${testdir}/${keystore}" ]]
rm -rf "$testdir"

echo "## creates a certificate named after the cwd"
testdir=$(mktemp -d)
cp localcert.mk "$testdir"
proj=$(echo "$testdir" | rev | cut -d / -f 1 | rev)
cert="${proj}-localhost.crt"
echo "$makefile" > "${testdir}/Makefile" && make -s -C "$testdir" "$cert"
[[ -f "${testdir}/${cert}" ]]
rm -rf "$testdir"

echo "# about overriding the project name"

makefile=$(cat <<'eom'
PROJECT:=test
include localcert.mk
eom
)
proj=test

echo "## creates a keystore named after the project name"
testdir=$(mktemp -d)
cp localcert.mk "$testdir"
keystore="${proj}-localhost.jks"
echo "$makefile" > "${testdir}/Makefile" && make -s -C "$testdir" "$keystore"
[[ -f "${testdir}/${keystore}" ]]
rm -rf "$testdir"

echo "## creates a certificate named after the cwd"
testdir=$(mktemp -d)
cp localcert.mk "$testdir"
cert="${proj}-localhost.crt"
echo "$makefile" > "${testdir}/Makefile" && make -s -C "$testdir" "$cert"
[[ -f "${testdir}/${cert}" ]]
rm -rf "$testdir"

