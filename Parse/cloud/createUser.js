Parse.Cloud.define("createUser", function(request, response) {
	var user = new Parse.User();
	user.set("username",request.params.username);
	user.set("phone",request.params.phone)
	user.set("admin",false);
	user.set("password",request.params.password)
	user.set("email",request.params.email)
	user.set("emailVerified",false)
	user.set("location","none")
	user.set("picture","none")

	user.signUp(null,{
		success: function(user){
			response.success("success!!")

		},

		error: function(user,error){

			response.success("error! :(")
		}
	});
});