node-zooz
=========

[![Build Status](https://magnum.travis-ci.com/Bizzby/node-zooz.png?token=1Hwe9k9XH8cpee5HViHn&branch=master)](https://magnum.travis-ci.com/Bizzby/node-zooz)

Zooz Payment gateway node.js integration library

The library exposes API calls from both

* zooz extended server API
* zooz web mobile API

usage
-----

```JavaScript
var ZoozGateway = require('node -zooz').gateway;

var apiKeys = {
  "extendedServer": {
    "developerId": "john@gmail.com",
    "serverAPIKey": "111111111"
  },
  "web": {
    "ZooZUniqueID": "dev.company",
    "ZooZAppKey": "w2353453245234534"
  }
}

zgw = new ZoozGateway(apiKeys);

zgw.openTransaction(1000, 'GBP', 'userId_1', 'REF#1', function(err, token){
  console.log('TOEKN', token);
});
```

test
----

npm test