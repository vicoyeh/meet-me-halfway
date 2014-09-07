

var model = function() {
		
	//yelp
	var yelp = require("yelp").createClient({
		consumer_key: "OVnCuAcOBGzXKMNwzrKUaA", 
		consumer_secret: "G-rBtIZcXPSyFzY8jNEk_SnUv9Q",
		token: "wF8QqSoXa04Jrl3ogDxB54j7lAuthtd-",
     	token_secret: "SeWWHLSIjUegPPFUwu-Qigc3qqk"
	});

	var restaurants=[];

	return  {

		giveRestaurants : function(user,friend) {
			var dx = friend.longitude-user.longitude;
			var dy = friend.latitude-user.latitude;
			var distance = Math.sqrt(Math.pow(dx,2)+Math.pow(dy,2));
			var halfway = distance/2;

			var center = {
				latitude: user.latitude+(dy/2),
				longitude: user.longitude+(dx/2)
			}; //{latitude,longitude}

			center_location = center.latitude.toString() + "," + center.longitude.toString();

			yelp.search({term: "food", ll: center_location , limit: 2, sort: 2}, function(error, data) {
			  	if (data) {
					//console.log(data);
					for (var i = 0 ; i < data.businesses.length; i ++) {
						console.log(data.businesses[i].name);
						restaurants.push(data.businesses[i].name);
					}
					
				}
			});

			return restaurants;
		}
	}
}

module.exports = model;