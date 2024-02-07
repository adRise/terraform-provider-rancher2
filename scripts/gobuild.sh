#!/usr/bin/env bash

set -e

source $(dirname $0)/version.sh

echo "==> Building code binaries version ${VERSION} ..."

declare -A OS_ARCH_ARG

OS_PLATFORM_ARG=(linux windows darwin freebsd openbsd)
OS_ARCH_ARG[linux]="amd64"
OS_ARCH_ARG[darwin]="amd64 arm64"

BIN_NAME="terraform-provider-rancher2"
BUILD_DIR=$(dirname $0)"/../build/bin"


# CGO_ENABLED=0 go build -ldflags="-w -s -X main.VERSION=$VERSION -extldflags -static" -o bin/${BIN_NAME}

rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
for OS in ${OS_PLATFORM_ARG[@]}; do
    for ARCH in ${OS_ARCH_ARG[${OS}]}; do
        OUTPUT_BIN="${BUILD_DIR}/${BIN_NAME}_${OS}_${ARCH}"
        echo "Building binary for $OS/$ARCH..."
        GOARCH=$ARCH GOOS=$OS CGO_ENABLED=0 go build \
              -ldflags="-w -X main.VERSION=$VERSION" \
              -o ${OUTPUT_BIN} ./
    done
done
