// (c) Gooey 2016
// createUser.js : Creates an account and adds several fields to user account.

Parse.Cloud.define("createUser", function (request, response) {
	var user = new Parse.User();
	setNewAccountFieldsFor(user, request);
	signUp(user, response);
});

function setNewAccountFieldsFor(user, request) {
	user.set("username", request.params.username);
	user.set("phone", request.params.phone);
	user.set("admin", false);
	user.set("password", request.params.password);
	user.set("email", request.params.email);
	user.set("location", "none");
	user.set("picture", "none");
}

function signUp(user, response) {
	user.signUp(null, {
		success: function(user){
			response.success("success!!");
		},
		error: function(user,error){
			response.success("error! :(" + error.message);
		}
	});
}