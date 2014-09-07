var express = require('express');
var router = express.Router();

var map_model = require('../models/maps')();



router.post('/', function(req, res) {
	console.log("Received req")
	console.log(req);
  	var user = req.body.user;
  	var friend = req.body.friend;

  	console.log(user);
  	console.log(friend);

  	//var user = {"latitude":35.7749290,"longitude":-118.4194160};
  	//var friend = {"latitude":39.7749290,"longitude":-126.4194160};

  	//var restaurants = map_model.giveRestaurants(user,friend);
	
  	var output={name:"yo"};
  	res.set('Content-Type','application/json');
  	res.send(JSON.stringify(output));
  	//res.send(restaurants.toString());
});

module.exports = router;
