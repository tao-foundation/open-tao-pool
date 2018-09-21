#!/bin/sh

echo "Upgrading packages"

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

echo "Checking go & node version"

go version
node -v

echo "Upgrading EOS Classic"

git clone https://github.com/eosclassic/node-eosclassic
cd node-eosclassic
git pull
cargo build --release --features final
sudo cp target/release/parity /usr/local/bin/parity
cd .. && sudo rm -r node-eosclassic

echo "Upgrading EOS Classic Pool Software"

git clone https://github.com/eosclassic/open-eosc-pool --recursive
cd open-eosc-pool
git pull
make all
sudo cp build/bin/open-eosc-pool /usr/local/bin/open-eosc-pool
cd .. && sudo rm -r open-eosc-pool

echo "Done Upgrading EOS Classic & EOS Classic Pool Software!"
