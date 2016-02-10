// (c) Gooey 2016
// createOrder.js : Creates an order

Parse.Cloud.define("createOrder", function (request, response) {
	var Order = Parse.Object.extend("Order");
	var order = new Order();
	var param = request.params;

	//set values

	order.set("expirationDate", null);//null for now
	order.set("TimeSent",null);
	order.set("TimeDelivered",null);
	order.set("DeliveryAddress",param.DeliveryAddress);
	order.set("DeliveryZip",param.DeliveryZip);
	order.set("DeliveryState",param.DeliveryState);
	order.set("DeliveryCity",param.DeliveryCity);
	order.set("OrderDetails",param.OrderDetails);
	order.set("PickedUp",false);

	//get restaurant

	var rest = Parse.Object.extend("Restaurant");
	var query = new Parse.Query(rest);
	query.equalTo("name", param.restaurant);
	query.first({
  	success: function(rv) {
	    order.set("restaurant", rv);
	    order.save();
	  },
	  error: function(error) {
	    response.success("Error: " + error.code + " " + error.message);
	  }
	});

	order.set("OrderingUser", Parse.User.current())

	//save order

	order.save(null, {
	  success: function(r) {
	    // Execute any logic that should take place after the object is saved.
	    response.success('New object created with objectId: ' + r.id);
	  },
	  error: function(gameScore, error) {
	    response.success('Failed to create new object, with error code: ' + error.message);
	  }
	});

});