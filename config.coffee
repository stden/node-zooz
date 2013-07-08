module.exports =
  request:
    version: '1.0.0'
    method: 'POST'
    encoding: 'UTF-8'
    timeout: 5000
  extendedServer:
    url:
      sandbox: 'https://sandbox.zooz.co/mobile/ExtendedServerAPI'
      production: 'https://app.zooz.com/mobile/ExtendedServerAPI'
  web:
    url:
      sandbox: 'https://sandbox.zooz.co/mobile/SecuredWebServlet'
      production: 'https://app.zooz.com/mobile/ExtendedServerAPI'
  zoozIpAddrs: [
    '195.28.181.179'
    '91.228.127.99'
    '91.228.127.100'
    '195.28.181.191'
    '195.28.181.192'
  ]
