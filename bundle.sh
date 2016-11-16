#!/bin/bash

HASH=`git rev-parse --short HEAD`
BUNDLE=bundle-$HASH.tar.gz
S3ENDPOINT="s3://XXX/bundles/"

echo "[!] Removing any previous bundles..."
rm -rf bundle-*.tar.gz
echo "[*] Done!"

echo "[*] Creating bundle for commit $HASH..."
echo "[*] This operation may take several minutes..."
tar --exclude='*.git*' --exclude='*.DS_Store*' --exclude='storage/framework/*' --exclude='storage/logs/*' -zcf $BUNDLE -T bundle.conf > /dev/null 2>&1
echo "[*] Done!"

echo "[*] Uploading bundle to S3..."
aws s3 cp $BUNDLE $S3ENDPOINT > /dev/null 2>&1
echo "[*] Done!"

echo "[-] Your CodeDeploy S3 endpoint will be: $S3ENDPOINT$BUNDLE"
