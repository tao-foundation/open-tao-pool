## Open Source EOS Classic (EOSC) Mining Pool

[![Build Status](https://travis-ci.org/eosclassic/open-eosc-pool.svg?branch=master)](https://travis-ci.org/eosclassic/open-eosc-pool)
[![Build status](https://ci.appveyor.com/api/projects/status/ydvdrc0jb644h565/branch/master?svg=true)](https://ci.appveyor.com/project/eosclassicteam/open-eosc-pool/branch/master)
[![Go Report Card](https://goreportcard.com/badge/github.com/eosclassic/open-eosc-pool)](https://goreportcard.com/report/github.com/eosclassic/open-eosc-pool)
[![Discord](https://img.shields.io/badge/discord-join%20chat-blue.svg)](https://discord.gg/EEzNEEu)

### Features  

**This pool is being further developed to provide an easy to use pool for EOS Classic miners. Testing and bug submissions are welcome!**

**Parity client is MANDATORY. Previous Geth / EOSC node is no longer supported.**

* Support for HTTP and Stratum mining
* Detailed block stats with luck percentage and full reward
* Failover eosc instances: eosc high availability built in
* Modern beautiful Ember.js frontend
* Separate stats for workers: can highlight timed-out workers so miners can perform maintenance of rigs
* JSON-API for stats
* PPLNS block reward
* Multi-tx payout at once
* Beautiful front-end highcharts embedded
* Native Nicehash Stratum proxy support

#### Recommended miners for EOS Classic

* [Claymore's Dual Ethereum Miner](https://bitcointalk.org/index.php?topic=1433925.0) Stratum miner with dual algorithm mining support (2% dev fee)
* [Ethminer](https://github.com/ethereum-mining/ethminer/releases) Stratum miner with no dev fee & open-source
* [Nicehash](https://www.nicehash.com/?refby=359826) Rent a hash here if you don't have a miner

## Guide to make your very own EOS Classic mining pool

### Setting up a server for mining pool

It is recommended to setup a clean vps server for mining pool rather than building a mining pool on your laptop or desktop environment (for security and better performance)

Create an instance on AWS or Azure if you don't have one.

Following hardware spec is recommended for single pool server with full features enabled.

  * cpu > 2 core
  * ram > 4 gb
  * storage > 30 gb ( for redis & node )
  * bandwith > 10mb
  * os = linux (ubuntu or centos)

This will cost about 40$ per month

### Building on Linux

Dependencies:

  * go >= 1.11
  * redis-server >= 2.8.0
  * nodejs >= 8 LTS
  * nginx
  * parity-eosclassic

**I highly recommend to use Ubuntu 16.04 LTS.**

### Installing EOS Classic & EOS Classic Pool

Install required packages & EOS Classic Pool by the following command

    $ curl -sL https://raw.githubusercontent.com/eosclassic/open-eosc-pool/master/install.sh | sudo -E bash -

### Upgrading EOS Classic & EOS Classic Pool

Upgrade required packages & EOS Classic Pool by the following command

    $ curl -sL https://raw.githubusercontent.com/eosclassic/open-eosc-pool/master/upgrade.sh | sudo -E bash -    

Please backup your pool before upgrading!

### Clone open-eosc-pool repository

    $ git clone https://github.com/eosclassic/open-eosc-pool --recursive

### Set up eosc

If you use Ubuntu, it is easier to control services by using systemctl.

    $ sudo nano /etc/systemd/system/eosclassic.service

Copy the following example

```
[Unit]
Description=EOS Classic for Pool
After=network-online.target

[Service]
ExecStart=/usr/local/bin/parity --rpc --mine --extradata "Mined by <your-pool-domain>" --ethstats "<your-pool-domain>:EOSClassic@stats.eos-classic.io"
User=<your-user-name>

[Install]
WantedBy=multi-user.target
```

Then run eosc by the following commands

    $ sudo systemctl enable eosclassic
    $ sudo systemctl start eosclassic

If you want to debug the node command

    $ sudo systemctl status eosclassic

Run console

    $ eosc attach

Register pool account and open wallet for transaction. This process is always required, when the wallet node is restarted.

    > personal.newAccount()
    > personal.unlockAccount(eth.accounts[0],"password",40000000)

### Set up EOS Classic pool

    $ cp config/stratum.example.json config/stratum.json
    $ cp config/unlocker.example.json config/unlocker.json
    $ cp config/payout.example.json config/payout.json
    $ cp config/api.example.json config/api.json

Set up based on commands below.

```javascript
{
  // The number of cores of CPU.
  "threads": 2,
  // Prefix for keys in redis store
  "coin": "eosc",
  // Give unique name to each instance
  "name": "main",
  // PPLNS rounds
  "pplns": 9000,

  "proxy": {
    "enabled": true,

    // Bind HTTP mining endpoint to this IP:PORT
    "listen": "0.0.0.0:8888",

    // Allow only this header and body size of HTTP request from miners
    "limitHeadersSize": 1024,
    "limitBodySize": 256,

    /* Set to true if you are behind CloudFlare (not recommended) or behind http-reverse
      proxy to enable IP detection from X-Forwarded-For header.
      Advanced users only. It's tricky to make it right and secure.
    */
    "behindReverseProxy": false,

    // Stratum mining endpoint
    "stratum": {
      "enabled": true,
      // Bind stratum mining socket to this IP:PORT
      "listen": "0.0.0.0:8008",
      "timeout": "120s",
      "maxConn": 8192
    },

    // Nicehash mining endpoint
    "nicehash": {
      "enabled": false,
      // Bind stratum mining socket to this IP:PORT
      "listen": "0.0.0.0:8088",
      "timeout": "120s",
      "maxConn": 8192
    },

    // Try to get new job from eosc in this interval
    "blockRefreshInterval": "120ms",
    "stateUpdateInterval": "3s",
    // If there are many rejects because of heavy hash, difficulty should be increased properly.
    "difficulty": 2000000000,

    /* Reply error to miner instead of job if redis is unavailable.
      Should save electricity to miners if pool is sick and they didn't set up failovers.
    */
    "healthCheck": true,
    // Mark pool sick after this number of redis failures.
    "maxFails": 100,
    // TTL for workers stats, usually should be equal to large hashrate window from API section
    "hashrateExpiration": "3h",

    "policy": {
      "workers": 8,
      "resetInterval": "60m",
      "refreshInterval": "1m",

      "banning": {
        "enabled": false,
        /* Name of ipset for banning.
        Check http://ipset.netfilter.org/ documentation.
        */
        "ipset": "blacklist",
        // Remove ban after this amount of time
        "timeout": 1800,
        // Percent of invalid shares from all shares to ban miner
        "invalidPercent": 30,
        // Check after after miner submitted this number of shares
        "checkThreshold": 30,
        // Bad miner after this number of malformed requests
        "malformedLimit": 5
      },
      // Connection rate limit
      "limits": {
        "enabled": false,
        // Number of initial connections
        "limit": 30,
        "grace": "5m",
        // Increase allowed number of connections on each valid share
        "limitJump": 10
      }
    }
  },

  // Provides JSON data for frontend which is static website
  "api": {
    "enabled": true,
    "listen": "0.0.0.0:8080",
    // Collect miners stats (hashrate, ...) in this interval
    "statsCollectInterval": "5s",
    // Purge stale stats interval
    "purgeInterval": "10m",
    // Fast hashrate estimation window for each miner from it's shares
    "hashrateWindow": "30m",
    // Long and precise hashrate from shares, 3h is cool, keep it
    "hashrateLargeWindow": "3h",
    // Collect stats for shares/diff ratio for this number of blocks
    "luckWindow": [64, 128, 256],
    // Max number of payments to display in frontend
    "payments": 50,
    // Max numbers of blocks to display in frontend
    "blocks": 50,
    // Frontend Chart related settings
    "poolCharts":"0 */20 * * * *",
    "poolChartsNum":74,
    "minerCharts":"0 */20 * * * *",
    "minerChartsNum":74

    /* If you are running API node on a different server where this module
      is reading data from redis writeable slave, you must run an api instance with this option enabled in order to purge hashrate stats from main redis node.
      Only redis writeable slave will work properly if you are distributing using redis slaves.
      Very advanced. Usually all modules should share same redis instance.
    */
    "purgeOnly": false
  },

  // Check health of each eosc node in this interval
  "upstreamCheckInterval": "5s",

  /* List of eosc nodes to poll for new jobs. Pool will try to get work from
    first alive one and check in background for failed to back up.
    Current block template of the pool is always cached in RAM indeed.
  */
  "upstream": [
    {
      "name": "main",
      "url": "http://127.0.0.1:8282",
      "timeout": "10s"
    },
    {
      "name": "backup",
      "url": "http://127.0.0.2:8282",
      "timeout": "10s"
    }
  ],

  // This is standard redis connection options
  "redis": {
    // Where your redis instance is listening for commands
    "endpoint": "127.0.0.1:6379",
    "poolSize": 10,
    "database": 0,
    "password": ""
  },

  // This module periodically remits ether to miners
  "unlocker": {
    "enabled": true,
    // Pool fee percentage
    "poolFee": 1.0,
    // the address is for pool fee. Personal wallet is recommended to prevent from server hacking.
    "poolFeeAddress": "",
    // Amount of donation to eos classic development fund. 5 percent of pool fee is donated to eos classic development fund now. If pool fee is 1 percent, 0.05 percent which is 5 percent of pool fee should be donated to eos classic development fund.
    "donate": true,
    // Unlock only if this number of blocks mined back
    "depth": 120,
    // Simply don't touch this option
    "immatureDepth": 20,
    // Keep mined transaction fees as pool fees
    "keepTxFees": false,
    // Run unlocker in this interval
    "interval": "10m",
    // EOSC instance node rpc endpoint for unlocking blocks
    "daemon": "http://127.0.0.1:8282",
    // Rise error if can't reach eosc in this amount of time
    "timeout": "10s"
  },

  // Pay out miners using this module
  "payouts": {
    "enabled": true,
    // Require minimum number of peers on node
    "requirePeers": 2,
    // Run payouts in this interval
    "interval": "10m",
    // EOSC instance node rpc endpoint for payouts processing
    "daemon": "http://127.0.0.1:8282",
    // Rise error if can't reach eosc in this amount of time
    "timeout": "10s",
    // Address with pool coinbase wallet address.
    "address": "0x0",
    // Let eosc to determine gas and gasPrice
    "autoGas": true,
    // Gas amount and price for payout tx (advanced users only)
    "gas": "21000",
    "gasPrice": "50000000000",
    // The minimum distribution of mining reward. It is 0.5 EOSC now.
    "threshold": 500000000,
    // Perform BGSAVE on Redis after successful payouts session
    "bgsave": false
    "concurrentTx": 10
  }
}
```

If you are distributing your pool deployment to several servers or processes,
create several configs and disable unneeded modules on each server.

I recommend this deployment strategy:

* Stratum Mining Process (You can only enable stratum.json if you are solo mining and you don't need payouts)
* Nicehash Mining Process (Enable nicehash with nicehash.json, you should not enable nicehash proxy with default stratum proxy at a same time, seperate them!!)
* Unlocker and payouts Process - 1x each (strict!)
* API Process - 1x for website


### Run Pool

It is required to run pool by serviced. If it is not, the terminal could be stopped, and pool doesn’t work.

Copy the following example

**Main Stratum Proxy for mining**

    $ sudo nano /etc/systemd/system/eoscpool-main.service

```
[Unit]
Description=EOS Classic Mining Pool - Stratum
After=eosclassic.target

[Service]
Type=simple
ExecStart=/usr/local/bin/open-eosc-pool /home/<your-user-name>/open-eosc-pool/config/stratum.json
User=<your-user-name>

[Install]
WantedBy=multi-user.target
```

**Unlocker for eosc node**

    $ sudo nano /etc/systemd/system/eoscpool-unlocker.service

```
[Unit]
Description=EOS Classic Mining Pool - Unlocker
After=eosclassic.target

[Service]
Type=simple
ExecStart=/usr/local/bin/open-eosc-pool /home/<your-user-name>/open-eosc-pool/config/unlocker.json
User=<your-user-name>

[Install]
WantedBy=multi-user.target
```

**Payout module for miners**

    $ sudo nano /etc/systemd/system/eoscpool-payout.service

```
[Unit]
Description=EOS Classic Mining Pool - Payout
After=eosclassic.target

[Service]
Type=simple
ExecStart=/usr/local/bin/open-eosc-pool /home/<your-user-name>/open-eosc-pool/config/payout.json
User=<your-user-name>

[Install]
WantedBy=multi-user.target
```

**API for Website**

    $ sudo nano /etc/systemd/system/eoscpool-api.service

```
[Unit]
Description=EOS Classic Mining Pool - API
After=eosclassic.target

[Service]
Type=simple
ExecStart=/usr/local/bin/open-eosc-pool /home/<your-user-name>/open-eosc-pool/config/api.json
User=<your-user-name>

[Install]
WantedBy=multi-user.target
```

Then run pool by the following commands

    $ sudo systemctl start eoscpool-main
    $ sudo systemctl start eoscpool-unlocker
    $ sudo systemctl start eoscpool-payout
    $ sudo systemctl start eoscpool-api

If you want to debug the node command

    $ sudo systemctl status eoscpool-main

Backend operation has completed so far.

### Open Firewall

Firewall should be opened to operate this service. Whether Ubuntu firewall is basically opened or not, the firewall should be opened based on your situation.
You can open firewall by opening 80,443,8080,8888,8008.

## Install Frontend

### Clone frontend submodule

Make sure you've cloned your pool frontend submodule, some git programs aren't configured to clone them by default

    $ git submodule update --init --recursive

### Modify configuration file

    $ nano ~/open-eosc-pool/www/config/environment.js

Make some modifications in these settings.

    BrowserTitle: 'EOS Classic Mining Pool',
    ApiUrl: '//your-pool-domain/',
    HttpHost: 'http://your-pool-domain',
    StratumHost: 'your-pool-domain',
    PoolFee: '1%',

The frontend is a single-page Ember.js application that polls the pool API to render miner stats.

    $ cd ~/open-eosc-pool/www
    $ sudo npm install -g ember-cli@2.9.1
    $ sudo npm install -g bower
    $ sudo chown -R $USER:$GROUP ~/.npm
    $ sudo chown -R $USER:$GROUP ~/.config
    $ npm install
    $ bower install
    $ ./build.sh
    $ cp -R ~/open-eosc-pool/www/dist ~/www

As you can see above, the frontend of the pool homepage is created. Then, move to the directory, www, which services the file.

Set up nginx.

    $ sudo nano /etc/nginx/sites-available/site01

Modify based on configuration file.

    upstream api {
        server 127.0.0.1:8080;
    }

    server {
        listen 80;
        listen [::]:80;
        root /home/<your-user-name>/www;

        # Add index.php to the list if you are using PHP
        index index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
        }

        location /api {
                proxy_pass http://api;
        }

    }

After setting nginx is completed, run the command below.

    $ sudo rm /etc/nginx/sites-enabled/default
    $ sudo ln -s /etc/nginx/sites-available/site01 /etc/nginx/sites-enabled/site01
    $ sudo service nginx restart

Type your homepage address or IP address on the web.
If you face screen without any issues, pool installation has completed.

### Extra) How To Secure the pool frontend with Let's Encrypt (https)

This guide was originally referred from [digitalocean - How To Secure Nginx with Let's Encrypt on Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-16-04)

First, install the Certbot's Nginx package with apt-get

```
$ sudo add-apt-repository ppa:certbot/certbot
$ sudo apt-get update
$ sudo apt-get install python-certbot-nginx
```

And then open your nginx setting file, make sure the server name is configured!

```
$ sudo nano /etc/nginx/sites-available/default
. . .
server_name <your-pool-domain>;
. . .
```

Change the _ to your pool domain, and now you can obtain your auto-renewaled ssl certificate for free!

```
$ sudo certbot --nginx -d <your-pool-domain>
```

Now you can access your pool's frontend via https! Share your pool link!

### Notes

* Unlocking and payouts are sequential, 1st tx go, 2nd waiting for 1st to confirm and so on. You can disable that in code. Carefully read `docs/PAYOUTS.md`.
* Also, keep in mind that **unlocking and payouts will halt in case of backend or node RPC errors**. In that case check everything and restart.
* You must restart module if you see errors with the word *suspended*.
* Don't run payouts and unlocker modules as part of mining node. Create separate configs for both, launch independently and make sure you have a single instance of each module running.
* If `poolFeeAddress` is not specified all pool profit will remain on coinbase address. If it specified, make sure to periodically send some dust back required for payments.
* DO NOT OPEN YOUR RPC OR REDIS ON 0.0.0.0!!! It will eventually cause coin theft.

### Credits

Made by sammy007. Licensed under GPLv3.

Modified by Akira Takizawa & The Ellaism Project & EOS Classic.

#### Contributors

[Alex Leverington](https://github.com/subtly)

### Donations

Consider a donation for eos classic development fund!!

Official EOS Classic Development Fund: [0x63fc6bf24415D69FD03B4eABa425A4fB3310ccc7](https://explorer.eos-classic.io/addr/0x63fc6bf24415d69fd03b4eaba425a4fb3310ccc7)

![](https://cdn.pbrd.co/images/GP5tI1D.png)

Highly appreciated.
