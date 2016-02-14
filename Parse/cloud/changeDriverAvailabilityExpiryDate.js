// (c) Gooey 2016
// changeDriverAvailabilityExpiryDate.js : Change Expiration Date on driver availability

Parse.Cloud.define("changeDriverAvailabilityExpiryDate", function (request, response) {
	var param = request.params;

	var DA = Parse.Object.extend("DriverAvailability");
	var query = new Parse.Query(DA);
	var expiryDate = new Date(param.expiryYear,param.expiryMonth,param.expiryDay,
		param.expiryHour,param.expiryMinute,param.expirySeconds)
	query.equalTo("driver", Parse.User.current());
	query.first({
	  success: function(rv) {
	    rv.set("expiryDate", expiryDate);
	    rv.save();
	    response.success("Here");
	  },
	  error: function(error) {
	    alert("Error: " + error.code + " " + error.message);
	  }
	});
});