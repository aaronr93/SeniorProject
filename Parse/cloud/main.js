require('cloud/app.js');
require('cloud/test.js');
<<<<<<< HEAD
require('cloud/createUser.js');
=======
require('cloud/login.js');
>>>>>>> origin/master

Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

