## Open Source TEO Mining Pool

[![Build Status](https://travis-ci.org/tao-foundation/open-tao-pool.svg?branch=master)](https://travis-ci.org/tao-foundation/open-tao-pool)
[![Build status](https://ci.appveyor.com/api/projects/status/ydvdrc0jb644h565/branch/master?svg=true)](https://ci.appveyor.com/project/tao-foundation/open-tao-pool/branch/master)
[![Go Report Card](https://goreportcard.com/badge/github.com/tao-foundation/open-tao-pool)](https://goreportcard.com/report/github.com/tao-foundation/open-tao-pool)
[![Discord](https://img.shields.io/badge/discord-join%20chat-blue.svg)](https://discord.gg/EEzNEEu)

### Features  

**This pool is being further developed to provide an easy to use pool for TEO miners. Testing and bug submissions are welcome!**

* Support for HTTP and Stratum mining
* Detailed block stats with luck percentage and full reward
* Failover miner instances: TEO high availability built in
* Separate stats for workers: can highlight timed-out workers so miners can perform maintenance of rigs
* JSON-API for stats
* PPLNS block reward
* Multi-tx payout at once

### Building on Linux

Dependencies:

  * go >= 1.9

**I highly recommend to use Ubuntu 16.04 LTS.**

Clone & compile:

    git clone https://github.com/tao-foundation/open-tao-pool.git
    cd open-tao-pool
    make

### Running Pool & Building Frontend

FrontEnd Code is on WWW

```
npm install
bower install
./build.sh
```


### Credits

Made by sammy007. Licensed under GPLv3.

Modified by Akira Takizawa & The Ellaism Project & EOS Classic.

#### Contributors

[Alex Leverington](https://github.com/subtly)
