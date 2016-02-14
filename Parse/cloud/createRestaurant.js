// (c) Gooey 2016
// createRestaurant.js : Creates an restaurant

Parse.Cloud.define("createRestaurant", function (request, response) {
	var Restaurant = Parse.Object.extend("Restaurant");
	var restaurant = new Restaurant();
	var param = request.params;


	restaurant.set("name",param.name);
	restaurant.set("address",param.address);
	restaurant.set("zip",param.zip);
	restaurant.set("state",param.state);
	restaurant.set("city",param.city);
	restaurant.set("orderCount",0);

	//save order

	restaurant.save();

});