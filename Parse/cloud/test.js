Parse.Cloud.define("numUsers", function(request, response) {
	var query = new Parse.Query("User");
	query.count({
			success: function(count) {
				response.success("there are " + count + " users");
			}
		});

});

Parse.Cloud.define("getUser", function(request, response) {
	var User = Parse.Object.extend("User");
	var query = new Parse.Query(User);
	query.equalTo("objectId", "iXxaIPVCbM");
	query.first({
	  success: function(object) {
	    response.success(object.get("phone"));
	  },
	  error: function(error) {
	    alert("Error: " + error.code + " " + error.message);
	  }
	});
});
