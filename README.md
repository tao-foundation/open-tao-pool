## Open Source EOS Classic (EOSC) Mining Pool

[![Build Status](https://travis-ci.org/eosclassic/open-eosc-pool.svg?branch=master)](https://travis-ci.org/eosclassic/open-eosc-pool)
[![Build status](https://ci.appveyor.com/api/projects/status/ydvdrc0jb644h565/branch/master?svg=true)](https://ci.appveyor.com/project/eosclassicteam/open-eosc-pool/branch/master)
[![Go Report Card](https://goreportcard.com/badge/github.com/eosclassic/open-eosc-pool)](https://goreportcard.com/report/github.com/eosclassic/open-eosc-pool)
[![Discord](https://img.shields.io/badge/discord-join%20chat-blue.svg)](https://discord.gg/EEzNEEu)

### Features  

**This pool is being further developed to provide an easy to use pool for EOS Classic miners. Testing and bug submissions are welcome!**

* Support for HTTP and Stratum mining
* Detailed block stats with luck percentage and full reward
* Failover eosc instances: eosc high availability built in
* Separate stats for workers: can highlight timed-out workers so miners can perform maintenance of rigs
* JSON-API for stats
* PPLNS block reward
* Multi-tx payout at once

### Building on Linux

Dependencies:

  * go >= 1.9

**I highly recommend to use Ubuntu 16.04 LTS.**

Clone & compile:

    git clone https://github.com/eosclassic/open-eosc-pool.git
    cd open-eosc-pool
    make

### Running Pool & Building Frontend

Official guide for EOS Classic Mining Pool has been moved to [eosc-mining-pool](https://github.com/eosclassic/eosc-mining-pool/blob/master/README.md) with example source code for frontend deployment.

### Credits

Made by sammy007. Licensed under GPLv3.

Modified by Akira Takizawa & The Ellaism Project & EOS Classic.

#### Contributors

[Alex Leverington](https://github.com/subtly)
