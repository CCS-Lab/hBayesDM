#!/bin/bash
# Written by Jetho Lee

for i in `ls models/[a-z]*.json`; do
  echo "========== $i =========="
  jsonschema -i "$i" ModelInformation.schema.json
done
