#!/bin/sh

echo "Installing required packages"

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y install build-essential libudev-dev file cmake golang-1.10-go unzip
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
curl https://sh.rustup.rs -sSf | sh -s -- -y
export PATH="$HOME/.cargo/bin:$PATH"

echo "Checking go & node version"

go version
node -v
rustc --version

echo "Installing EOS Classic"

mkdir .eosc-temp
git clone https://github.com/eosclassic/node-eosclassic .eosc-temp/node-eosclassic
cd .eosc-temp/node-eosclassic
cargo build --release --features final
sudo cp target/release/eosc /usr/local/bin/eosc
cd ../.. && sudo rm -r .eosc-temp/node-eosclassic

echo "Installing EOS Classic Pool Software"

git clone https://github.com/eosclassic/open-eosc-pool .eosc-temp/open-eosc-pool --recursive
cd .eosc-temp/open-eosc-pool
make all
sudo cp build/bin/open-eosc-pool /usr/local/bin/open-eosc-pool
cd ../.. && sudo rm -r .eosc-temp/open-eosc-pool

echo "Done installing EOS Classic & EOS Classic Pool Software!, Please configure your pool with the following instructions on https://github.com/eosclassic/open-eosc-pool/blob/master/README.md"
