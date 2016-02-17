Parse.Cloud.define("getRequestsImPickingUp", function(request, response) {
	var orders = Parse.Object.extend("Order");
	var query = new Parse.Query(orders);
	query.equalTo("driverToDeliver", {__type: "Pointer", className: "_User",objectId: request.params.userId});
	query.find({
		success: function(object) {
			response.success(object);
		}, error: function(error) {
			response.error("Error: " + error.code + " " + error.message);
		}
	});
});