# Dev image with Swift 5.9 and libsecp256k1 preinstalled
FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

# Install base deps
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    git \
    build-essential \
    autoconf \
    automake \
    libtool \
    pkg-config \
    libssl-dev \
    libgmp-dev \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Swift (official binary release)
ENV SWIFT_VERSION=5.9.3-RELEASE
RUN curl -sLO https://download.swift.org/releases/$SWIFT_VERSION/swift-$SWIFT_VERSION-ubuntu24.04.tar.gz \
    && tar -xzf swift-$SWIFT_VERSION-ubuntu24.04.tar.gz -C / \
    && rm swift-$SWIFT_VERSION-ubuntu24.04.tar.gz \
    && ln -s /swift-$SWIFT_VERSION-ubuntu24.04/usr/bin/swift /usr/bin/swift

# Build & install libsecp256k1
RUN git clone https://github.com/bitcoin-core/secp256k1.git /tmp/secp256k1 \
    && cd /tmp/secp256k1 \
    && ./autogen.sh \
    && ./configure --enable-module-ext --enable-experimental \
    && make -j$(nproc) \
    && make install \
    && ldconfig \
    && rm -rf /tmp/secp256k1

# Create non-root user
RUN useradd -ms /bin/bash dev && mkdir -p /home/dev/workspace && chown -R dev:dev /home/dev
USER dev
WORKDIR /home/dev/workspace

CMD ["bash"]
