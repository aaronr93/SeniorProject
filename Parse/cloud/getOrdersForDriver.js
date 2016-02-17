// (c) Gooey 2016
// createOrder.js : Creates an order

Parse.Cloud.define("getOrdersForDriver", function (request, response) {
	var param = request.params;
	var Order = Parse.Object.extend("Order");

	var User = Parse.Object.extend("User");
	var query = new Parse.Query(User);
	query.equalTo("objectId", param.user);
	query.first({
	  success: function(user) {
	    var orderQuery = new Parse.Query(Order);
		orderQuery.equalTo("driverToDeliver", user);
		orderQuery.find({
		  success: function(rv) {
		    response.success(rv);
		  },
		  error: function(error) {
		    response.error("Error: " + error.code + " " + error.message);
		  }
		});
	  },
	  error: function(error) {
	    response.error("Error: " + error.code + " " + error.message);
	  }
	});	
});