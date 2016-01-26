Parse.Cloud.define("numUsers", function(request, response) {
	var query = new Parse.Query("User");
	query.count({
			success: function(count) {
				response.success("there are " + count + " users");
			}
		});

});