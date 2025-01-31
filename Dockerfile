FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    jq \
    make \
    gcc \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Go
RUN wget https://go.dev/dl/go1.23.5.linux-arm64.tar.gz && \
    tar -C /usr/local -xzf go1.23.5.linux-arm64.tar.gz && \
    rm go1.23.5.linux-arm64.tar.gz

# Set Go environment variables
ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=/go
ENV PATH=$PATH:$GOPATH/bin

# Install Babylond for testnet 
COPY . /app
WORKDIR /app/babylon

RUN git fetch origin && \
    git checkout v1.0.0-rc.3 && \
    BABYLON_BUILD_OPTIONS="testnet" make install
    
RUN cd .. && rm -rf babylon

# Verify installation
RUN babylond version

# Create directory for chain data
RUN mkdir -p /root/.babylond

# Set working directory
WORKDIR /root

WORKDIR /
RUN rm -rf /babylon


CMD ["babylond", "version"]
