var express = require('express');
var router = express.Router();

var map_model = require('../models/maps')();



router.post('/', function(req, res) {
	res.set('Content-Type','application/json');
	console.log("Received req")
	// console.log(req.body.toString());

	var data = JSON.stringify(req.body)
	data = data.slice(2,data.length-4);
	console.log(data);
	data = JSON.parse(data);

  	var user = data.user;
  	var friend = data.friend;

  	console.log(user);
  	console.log(friend);

  	//var user = {"latitude":35.7749290,"longitude":-118.4194160};
  	//var friend = {"latitude":39.7749290,"longitude":-126.4194160};

  	//var restaurants = map_model.giveRestaurants(user,friend);
	
  	var output={name:"yo"};
  	res.send(JSON.stringify(output));
  	//res.send(restaurants.toString());
});

module.exports = router;
