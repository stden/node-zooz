module.exports = {

  "USD":{
    "ResponseObject":{
      "currencyCode":"USD",
      "fundSourceType":"MasterCard",
      "invoice":{
        "items":[
          {
            "id":"100101",
            "price":12.5,
            "name":"Coca Cola",
            "additionalDetails":"Can",
            "quantity":2
          },
          {
            "id":"100102",
            "price":10,
            "name":"Sprite",
            "additionalDetails":"Can",
            "quantity":2
          }
        ],
        "additionalDetails":"Invoice additional details",
        "number":"Invoice Number"
      },
      "transactionID":"7JU3VMGBXC4XJE343ASWF3W6C4",
      "appName":"Kartis",
      "amount":45,
      "isSandbox":"false",
      "lastFourDigits":"4444",
      "paidAmount":45,
      "transactionFee":0.17,
      "transactionTimestamp":1344953560718,
      "addresses":[
        {
          "billing": {
            "street":"Main St. 1",
            "city":"New York",
            "state":"New York",
            "zip":"643321",
            "country":"USA"
          }
        }
      ],
      "transactionStatus":"Succeed",
      "user":{
        "lastName":"Jones", 
        "phone":{
          "phoneNumber":"05481234567", 
          "countryCode":"001"
        }, 
        "email":"support@zooz.com", 
        "additionalDetails":"Additional User Details 1234",
        "firstName":"Tom"
      }
    },
    "ResponseStatus": 0
  },

  "pendingGBPVISA": {},
  "pendingGBPmastercard": {},
  "pendingGBPpaypal": {},

  "completedGBPVISA": {},
  "completedGBPmastercard": {},
  "completedGBPPaypal": {}
}
