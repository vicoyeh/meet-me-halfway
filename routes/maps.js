var express = require('express');
var bodyParser = require('body-parser');
var router = express.Router();

var map_model = require('../models/maps')();



router.post('/',[bodyParser.urlencoded(), bodyParser.json()], function(req, res) {
	res.set('Content-Type','application/json');
	console.log("Received req")

	//parse req object
	var arr = Object.keys(req.body);
	var str = arr[0];
	console.log(str);
	var data = JSON.parse(str);
	console.log(data);
  	console.log(data.user);
  	console.log(data.friend);

  	var user = data.user;
  	var friend = data.friend;

  	//test data
  	//var user = {"latitude":35.7749290,"longitude":-118.4194160};
  	//var friend = {"latitude":39.7749290,"longitude":-126.4194160};



  	map_model.giveRestaurants(user,friend,function(restaurants){
  		  	console.log(restaurants[0]);
			console.log(restaurants.toString());
		  	res.send(restaurants);
  	});

  	//res.send(restaurants.toString());
});

module.exports = router;
