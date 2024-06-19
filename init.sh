#!/bin/bash

CODE_VERSION=$(curl -s https://api.github.com/repos/coder/code-server/releases/latest | jq -r '.tag_name')
CODE_VERSION=${CODE_VERSION#v}
RUST_ANALYZER_VERSION=$(curl -s https://api.github.com/repos/rust-lang/rust-analyzer/releases/latest | jq -r '.tag_name')
CODELLDB_VERSION=$(curl -s https://api.github.com/repos/vadimcn/codelldb/releases/latest | jq -r '.tag_name')
CODELLDB_VERSION=${CODELLDB_VERSION#v}

sed -i "s/ARG CODE_VERSION=.*/ARG CODE_VERSION=${CODE_VERSION}/" Dockerfile
sed -i "s/ARG RUST_ANALYZER_VERSION=.*/ARG RUST_ANALYZER_VERSION=${RUST_ANALYZER_VERSION}/" Dockerfile
sed -i "s/ARG CODELLDB_VERSION=.*/ARG CODELLDB_VERSION=${CODELLDB_VERSION}/" Dockerfile