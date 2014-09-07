var express = require('express');
var router = express.Router();

var map_model = require('../models/maps')();



router.get('/', function(req, res) {
  	var user = req.body.user;
  	var friend = req.body.friend;
  	console.log("got request");
  	console.log(req.body);
  	console.log(user);
  	console.log(friend);


  	//var user = {"latitude":35.7749290,"longitude":-118.4194160};
  	//var friend = {"latitude":39.7749290,"longitude":-126.4194160};

  	var restaurants = map_model.giveRestaurants(user,friend);
	

  	
  	res.send(restaurants.toString());
});


router.post('/', function(req, res) {
  	var user = req.body.user;
  	var friend = req.body.friend;
  	console.log("got request");
  	console.log(req.body);
  	console.log(user);
  	console.log(friend);


  	//var user = {"latitude":35.7749290,"longitude":-118.4194160};
  	//var friend = {"latitude":39.7749290,"longitude":-126.4194160};

  	var restaurants = map_model.giveRestaurants(user,friend);
	
  	var data={"name":"yo"};
  	res.send(data);
  	//res.send(restaurants.toString());
});

module.exports = router;
