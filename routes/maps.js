var express = require('express');
var router = express.Router();

var map_model = require('../models/maps')();



router.post('/', function(req, res) {
	res.set('Content-Type','application/json');
	console.log("Received req")
	// console.log(req.body.toString());

	var str = JSON.stringify(req.body)
	str = data.slice(1,str.length-4);
	console.log(str);
	var data = JSON.parse(str);

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
