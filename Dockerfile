FROM ubuntu:trusty

RUN apt-get update && apt-get install -y \
  g++ \
  libzmq3-dev \
  libzmq3-dbg \
  libzmq3 \
  make \
  python \
  software-properties-common \
  curl \
  build-essential \
  libssl-dev \
  wget

RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get install -y nodejs

RUN apt-get install -y \
  libtool \
  autotools-dev \
  automake \
  pkg-config \
  libssl-dev \
  libevent-dev \
  bsdmainutils \
  git

RUN add-apt-repository ppa:bitcoin/bitcoin -y
RUN apt-get update
RUN apt-get install -y libdb4.8-dev libdb4.8++-dev

RUN apt-get install -y \
  libboost-system-dev \
  libboost-filesystem-dev \
  libboost-chrono-dev \
  libboost-program-options-dev \
  libboost-test-dev \
  libboost-thread-dev

# If you need to rebuild node from source.
# RUN git clone https://github.com/allgamescoindev/allgamescoin.git allgamescoin && \
#  cd allgamescoin && \
#  ./autogen.sh && \
#  ./configure --without-gui && make -j2

COPY bin /xagc

RUN npm config set package-lock false && npm install j4ys0n/allgamescoin-node

RUN ./node_modules/.bin/dashcore-node create xagc-node && \
  cd xagc-node && \
  ./node_modules/.bin/dashcore-node install j4ys0n/allgamescoin-insight-api && \
  ./node_modules/.bin/dashcore-node install j4ys0n/allgamescoin-insight-ui

RUN apt-get purge -y \
  g++ make python gcc && \
  apt-get autoclean && \
  apt-get autoremove -y

WORKDIR /xagc-node
COPY dashcore-node.json ./dashcore-node.json
COPY dash.conf ./data/dash.conf

RUN chmod +x /xagc/allgamescoind
RUN chmod +x /xagc/allgamescoin-cli

#PORT 3001 is for insight, 9998 is for rpc, 7208 is p2p
EXPOSE 3001 9998 7208

VOLUME /xagc-node/data

ENTRYPOINT ["/node_modules/.bin/dashcore-node", "start"]

#CMD tail -f /dev/null
