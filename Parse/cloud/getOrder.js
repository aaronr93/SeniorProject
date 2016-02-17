Parse.Cloud.define("getOrder", function(request, response) {
	var orders = Parse.Object.extend("Order");
	var query = new Parse.Query(orders);
	query.equalTo("objectId", request.params.orderId);
	query.first({
		success: function(object) {
			object.set("driverToDeliver", {__type: "Pointer", className: "_User",objectId: request.params.driverId});
			object.save(null, {
				success: function(){
					response.success("Driver got order");
				},
				error: function(){
					response.error("Couldn't set driver")
				}
				

			});
		}, error: function(error) {
			response.error("Error: " + error.code + " " + error.message);
		}
	});
});