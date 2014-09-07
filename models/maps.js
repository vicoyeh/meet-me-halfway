

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

		giveRestaurants : function(user,friend,callback) {
			var dx = friend.longitude-user.longitude;
			var dy = friend.latitude-user.latitude;
			var distance = Math.sqrt(Math.pow(dx,2)+Math.pow(dy,2));
			var halfway = distance/2;

			var center = {
				latitude: user.latitude+(dy/2),
				longitude: user.longitude+(dx/2)
			}; //{latitude,longitude}

			center_location = center.latitude.toString() + "," + center.longitude.toString();

			yelp.search({term: "food", ll: center_location , sort: 1}, function(error, data) {
			  	if (data) {
					//console.log(data);
					if  (data.businesses) {
						for (var i = 0 ; i < data.businesses.length; i ++) {

							var restaurant = {};

							//console.log(data.businesses[i].location.toString());
							
							if (restaurants.length==10) {
								break;
							}

							// console.log(data.businesses[i].name);
							restaurant.name = data.businesses[i].name;
							restaurant.rating = data.businesses[i].rating;
							restaurant.location = data.businesses[i].location;
							restaurant.rating_image_url = data.businesses[i].rating_img_url;
							restaurant.snippet_text = data.businesses[i].snippet_text;
							restaurant.mobile_url = data.businesses[i].mobile_url;
							restaurants.push(restaurant);

						}
					}
					callback(restaurants);
				}
			});
		}
	}
}

module.exports = model;