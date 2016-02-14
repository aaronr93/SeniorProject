// (c) Gooey 2016
// createDriverAvailableRestaurants.js

Parse.Cloud.define("createDriverAvailableRestaurants", function (request, response) {
	var DAR = Parse.Object.extend("DriverAvailableRestaurants");
	var dar = new DAR();
	var param = request.params;

	//get restaurant

	var rest = Parse.Object.extend("Restaurant");
	var query = new Parse.Query(rest);
	query.equalTo("objectId", param.restaurant);
	query.first({
  	success: function(rv) {
	    dar.set("restaurant", rv);
	    dar.save();
	  },
	  error: function(error) {
	    alert("Error: " + error.code + " " + error.message);
	  }
	});

	dar.set("driver", Parse.User.current())

	//save

	dar.save(null, {
	  success: function(r) {
	    // Execute any logic that should take place after the object is saved.
	    //response.success('New object created with objectId: ' + r.id);
	  },
	  error: function(gameScore, error) {
	    alert('Failed to create new object, with error code: ' + error.message);
	  }
	});

});