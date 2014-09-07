var express = require('express');
var router = express.Router();

var map_model = require('../models/maps')();



router.get('/', function(req, res) {
  	// var user = req.body.user;
  	// var friend = req.body.friend;
  	var user = {"latitude":35.7749290,"longitude":-118.4194160};
  	var friend = {"latitude":39.7749290,"longitude":-126.4194160};

  	var restaurants = map_model.giveRestaurants(user,friend);
	

  	
  	res.send(restaurants.toString());
});

module.exports = router;
