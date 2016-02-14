// (c) Gooey 2016
// createDriverAvailability.js : Creates an order

Parse.Cloud.define("createDriverAvailability", function (request, response) {
	var DA = Parse.Object.extend("DriverAvailability");
	var da = new DA();
	var param = request.params;

	da.set("expiryDate", null);//null for now
	da.set("isCurrentlyAvailable",false);


	da.set("driver", Parse.User.current())


	da.save();

});