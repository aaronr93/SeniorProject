Parse.Cloud.define("deleteOrder", function(request, response) {
	var orders = Parse.Object.extend("Order");
	var query = new Parse.Query(orders);
	query.equalTo("objectId", request.params.orderId);
	query.first({
		success: function(object) {
			object.set("deleted", true);
			object.save(null, {
				success: function(){
					response.success("Marked order as deleted");
				},
				error: function(){
					response.error("Couldn't mark order as deleted")
				}
				

			});
		}, error: function(error) {
			response.error("Error: " + error.code + " " + error.message);
		}
	});
});