// (c) Gooey 2016
// main.js

require('cloud/app.js');
require('cloud/test.js');
require('cloud/createUser.js');
require('cloud/login.js');
require('cloud/createOrder.js');
require('cloud/createDriverAvailableRestaurants.js')
require('cloud/createDriverAvailability.js')
require('cloud/createRestaurant.js')
require('cloud/changeDriverAvailabilityExpiryDate.js')


Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

