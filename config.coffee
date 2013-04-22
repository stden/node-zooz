config =

  development:
    version: '1.0.0'
    method: 'POST'
    encoding: 'UTF-8'
    timeout: 5000
    extendedServer:
      url: 'https://sandbox.zooz.co/mobile/ExtendedServerAPI'
    web:
      url: 'https://sandbox.zooz.co/mobile/SecuredWebServlet'

  testing:
    version: '1.0.0'
    method: 'POST'
    encoding: 'UTF-8'
    timeout: 5000
    extendedServer:
      url: 'https://sandbox.zooz.co/mobile/ExtendedServerAPI'
    web:
      url: 'https://sandbox.zooz.co/mobile/SecuredWebServlet'

  staging:
    version: '1.0.0'
    method: 'POST'
    encoding: 'UTF-8'
    timeout: 5000
    extendedServer:
      url: 'https://sandbox.zooz.co/mobile/ExtendedServerAPI'
    web:
      url: 'https://sandbox.zooz.co/mobile/SecuredWebServlet'

  production:
    version: '1.0.0'
    method: 'POST'
    encoding: 'UTF-8'
    timeout: 5000
    extendedServer:
      url: 'https://app.zooz.com/mobile/ExtendedServerAPI'
    web:
      url: 'https://app.zooz.com/mobile/SecuredWebServlet'


module.exports = (environment = process.env.NODE_ENV) ->
  throw new Error 'Environment not found' unless config[environment]?
  return config[environment]