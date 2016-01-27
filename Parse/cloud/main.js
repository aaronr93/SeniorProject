require('cloud/app.js');
require('cloud/test.js');
require('cloud/createUser.js');
require('cloud/login.js');

Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

