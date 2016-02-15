Parse.Cloud.define("deleteOrder", function(request, response) {
	var orders = Parse.Object.extend("Order");
	var query = new Parse.Query(orders);
	query.equalTo("objectId", request.params.orderId);
	query.first({
		success: function(object) {
			object.set("deleted", true);
			object.save(null, {
				success: function(){
					response.success("Saved successfully");
				},
				error: function(){
					response.error("couldn't save")
				}
				

			});
		}, error: function(error) {
			response.error("Error: " + error.code + " " + error.message);
		}
	});
});