#!/bin/bash

set -e

version=$1
if [ $# -eq 0 ]
  then
    echo "Please supply the version to release as the first argument" && exit 1
fi

echo "injection version: $version"
sed -i ''  "s/CONFLUENCE_VERSION=.*/CONFLUENCE_VERSION=$version/g" .env
sed -i ''  "s/ARG CONFLUENCE_VERSION=.*/ARG CONFLUENCE_VERSION=$version/g" Dockerfile
cp Dockerfile Dockerfile_de

echo "tagging with $version"
git add .env
git add Dockerfile
git add Dockerfile_de
git commit -am "releasing $version"
git tag $version
git push && git push --tags
