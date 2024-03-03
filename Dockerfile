# Use the official Ubuntu base image
FROM ubuntu:latest

# Install dependencies
RUN apt-get update && \
    apt-get install -y build-essential libtool autotools-dev automake pkg-config bsdmainutils python3 libssl-dev libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev libminiupnpc-dev libzmq3-dev libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler libqrencode-dev

# Clone Bitcoin repository
RUN apt-get install -y git
RUN git clone https://github.com/bitcoin/bitcoin.git /bitcoin

# Build Bitcoin
WORKDIR /bitcoin
RUN ./autogen.sh
RUN ./configure --with-gui=no
RUN make -j$(nproc)

# Install Bitcoin binaries
RUN make install

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /bitcoin

# Expose all Bitcoin ports
EXPOSE 8332 8333 18332 18333 18444 18443

# Set the entry point
CMD ["bitcoind", "-printtoconsole"]
