// (c) Gooey 2016
// createOrder.js : Creates an order

Parse.Cloud.define("createOrder", function (request, response) {
	var Order = Parse.Object.extend("Order");
	var order = new Order();
	var param = request.params;

	//set values
	var expiryDate = new Date(param.expiryYear,param.expiryMonth,param.expiryDay,
		param.expiryHour,param.expiryMinute,param.expirySeconds)
	order.set("expirationDate", expiryDate);//null for now
	order.set("TimeSent",null);
	order.set("timeDelivered",null);
	order.set("DeliveryAddress",param.DeliveryAddress);
	order.set("DeliveryZip",param.DeliveryZip);
	order.set("DeliveryState",param.DeliveryState);
	order.set("DeliveryCity",param.DeliveryCity);
	order.set("OrderDetails",param.OrderDetails);
	order.set("isAnyDriver",param.isAnyDriver);
	order.set("PickedUp",false);
	order.set("deleted",false);

	var User = Parse.Object.extend("User");
	var query = new Parse.Query(User);
	query.equalTo("objectId", param.driverToDeliver);
	query.first({
	  success: function(rv) {
	    order.set("driverToDeliver", rv);
	    order.save();
	  },
	  error: function(error) {
	    response.error("Error: " + error.code + " " + error.message);
	  }
	});

	//get restaurant

	var rest = Parse.Object.extend("Restaurant");
	var query = new Parse.Query(rest);
	query.equalTo("objectId", param.restaurant);
	query.first({
  	success: function(rv) {
	    order.set("restaurant", rv);
	    order.save();
	  },
	  error: function(error) {
	    response.error("Error: " + error.code + " " + error.message);
	  }
	});

	order.set("OrderingUser", Parse.User.current())

	//save order

	order.save(null, {
	  success: function(r) {
	    // Execute any logic that should take place after the object is saved.
	    //response.success('New object created with objectId: ' + r.id);
	  },
	  error: function(gameScore, error) {
	    response.error('Failed to create new object, with error code: ' + error.message);
	  }
	});

});