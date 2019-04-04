#!/bin/bash

VERSION="0.4.0"

docker build --no-cache -t xds2000/omnicore:${VERSION} .

docker tag xds2000/omnicore:${VERSION} xds2000/omnicore:latest
