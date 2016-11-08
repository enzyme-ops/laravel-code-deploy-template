#!/bin/bash

# Get the last commit hash
HASH=`git rev-parse --short HEAD`

# Create the bundle name
BUNDLE=bundle-$HASH.tar.gz

# Set the S3 bucket/foler endpoint
S3ENDPOINT="s3://XXX/bundles/"

echo "[!] Removing any previous bundles..."
rm -rf bundle-*.tar.gz
echo "[*] Done!"

echo "[*] Creating bundle for commit $HASH..."
tar --exclude='*.git*' --exclude='.env*' --exclude='*.DS_Store*' -zcf $BUNDLE * .??*
echo "[*] Done!"

echo "[*] Uploading bundle to S3..."
aws s3 cp $BUNDLE $S3ENDPOINT > /dev/null 2>&1
echo "[*] Done!"

echo "[-] Your CodeDeploy S3 endpoint is: $S3ENDPOINT$BUNDLE"
