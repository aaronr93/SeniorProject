Parse.Cloud.define("login", function(request, response){
	Parse.User.logIn(request.params.username, request.params.password, {
        success: function(results) 
        {   
            response.success(results);
        },
        error: function() {
            response.success("nothing found");
        }
    });

});