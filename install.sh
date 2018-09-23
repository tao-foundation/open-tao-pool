#!/bin/sh

echo "Installing golang"

export GO_VERSION=1.11
export GO_DOWNLOAD_URL=https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz

export GOPATH=/usr/local/lib/go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

sudo mkdir $GOPATH
sudo chown $USER -R $GOPATH

sudo apt update --fix-missing && apt upgrade -y
sudo apt install --no-install-recommends -y gcc

wget "$GO_DOWNLOAD_URL" -O golang.tar.gz
tar -zxvf golang.tar.gz
sudo mv go $GOROOT

echo "Installing required packages"

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y install build-essential unzip redis-server nginx screen gcc g++ libudev-dev pkg-config file make cmake
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
curl https://sh.rustup.rs -sSf | sh -s -- -y
export PATH="$HOME/.cargo/bin:$PATH"

echo "Checking go & node version"

go version
node -v

echo "Installing EOS Classic"

mkdir .eosc-temp
git clone https://github.com/eosclassic/node-eosclassic .eosc-temp/node-eosclassic
cd .eosc-temp/node-eosclassic
cargo build --release --features final
sudo cp target/release/parity /usr/local/bin/parity
cd ../.. && sudo rm -r .eosc-temp/node-eosclassic

echo "Installing EOS Classic Pool Software"

git clone https://github.com/eosclassic/open-eosc-pool .eosc-temp/open-eosc-pool --recursive
cd .eosc-temp/open-eosc-pool
make all
sudo cp build/bin/open-eosc-pool /usr/local/bin/open-eosc-pool
cd ../.. && sudo rm -r .eosc-temp/open-eosc-pool

echo "Done installing EOS Classic & EOS Classic Pool Software!, Please configure your pool with the following instructions on https://github.com/eosclassic/open-eosc-pool/blob/master/README.md"
