// (c) Gooey 2016
// main.js

require('cloud/app.js');
require('cloud/test.js');
require('cloud/createUser.js');
require('cloud/login.js');
<<<<<<< HEAD
require('cloud/newOrder.js');
=======
require('cloud/createOrder.js');
>>>>>>> d7d23e03c65a3630020e26db0a74fea8be498a1b

Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

