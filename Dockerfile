FROM ubuntu:22.04
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y \
    openssl libssl-dev \
    gdb-multiarch cmake \
    git wget python3 python3-pip vim file curl nano\
    autoconf automake autotools-dev libmpc-dev libmpfr-dev libgmp-dev \
    gawk build-essential bison flex texinfo gperf libtool patchutils bc \
    zlib1g-dev libexpat-dev \
    ninja-build pkg-config libglib2.0-dev libpixman-1-dev libsdl2-dev \
    jq \ 
    && rm -rf /var/lib/apt/lists/*

ARG CODE_VERSION=4.90.2
ARG RUST_ANALYZER_VERSION=2024-06-17
ARG CODELLDB_VERSION=1.10.0
RUN cd /usr/local/ && \
    wget https://github.com/coder/code-server/releases/download/v${CODE_VERSION}/code-server-${CODE_VERSION}-linux-amd64.tar.gz && \
    tar xf code-server-${CODE_VERSION}-linux-amd64.tar.gz && \
    ln -s  /usr/local/code-server-${CODE_VERSION}-linux-amd64/bin/code-server /usr/bin/code && \
    rm code-server-${CODE_VERSION}-linux-amd64.tar.gz && \
    wget https://github.com/rust-lang/rust-analyzer/releases/download/${RUST_ANALYZER_VERSION}/rust-analyzer-linux-x64.vsix && \
    code --install-extension rust-analyzer-linux-x64.vsix && \
    rm rust-analyzer-linux-x64.vsix && \
    wget https://github.com/vadimcn/codelldb/releases/download/v${CODELLDB_VERSION}/codelldb-x86_64-linux.vsix && \
    code --install-extension codelldb-x86_64-linux.vsix && \
    rm codelldb-x86_64-linux.vsix 

WORKDIR /root
ARG RUST_VERSION=stable
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-init && \
    chmod +x rustup-init && \
    ./rustup-init -y --default-toolchain ${RUST_VERSION} --target x86_64-unknown-linux-gnu && \
    rm rustup-init && \
    source $HOME/.cargo/env && \
    cargo install cargo-binutils && \
    cargo install cargo-generate && \
    cargo install cargo-deny --locked && \
    cargo install typos-cli && \
    cargo install git-cliff && \
    cargo install cargo-nextest --locked && \
    rustup component add llvm-tools-preview && \
    pip3 install pre-commit && \
    rustup component add rust-src

EXPOSE 8927/tcp
CMD ["code", "--auth", "none", "--bind-addr", "0.0.0.0:8927"]
