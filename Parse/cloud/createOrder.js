// (c) Gooey 2016
// createOrder.js : Creates an order

Parse.Cloud.define("createOrder", function (request, response) {
	var Order = Parse.Object.extend("Order");
	var order = new Order();
	var param = request.params;

	//set values

	order.set("expirationDate",null);//null for now
	order.set("TimeSent",null);
	order.set("DeliveryLocation",param.DeliveryLocation);
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
	    response.success(rv.get("name"));
	  },
	  error: function(error) {
	    response.success("Error: " + error.code + " " + error.message);
	  }
	});

	order.set("OrderingUser", Parse.User.current())
	order.set("PickedUp", false)

	//save order

	order.save(null, {
	  success: function(r) {
	    // Execute any logic that should take place after the object is saved.
	    //response.success('New object created with objectId: ' + r.id);
	  },
	  error: function(gameScore, error) {
	    // Execute any logic that should take place if the save fails.
	    // error is a Parse.Error with an error code and message.
	    //response.success('Failed to create new object, with error code: ' + error.message);
	  }
	});

});