var express = require('express');
var bodyParser = require('body-parser');
var router = express.Router();

var map_model = require('../models/maps')();



router.post('/',[bodyParser.urlencoded(), bodyParser.json()], function(req, res) {
	res.set('Content-Type','application/json');
	console.log("Received req")
	// console.log(req.body.toString());

	//console.log(req.body);
	//var data = JSON.parse(req.body);
	var arr = Object.keys(req.body);
	var str = arr[0];
	console.log(str);
	var data = JSON.parse(str);
	console.log(data);

	// var str = JSON.stringify(req.body);
	// str = str.slice(1,str.length-4);
	// console.log(str);
	// var data = JSON.parse(str);
	// console.log(data);
	// console.log(data);

  	console.log(data["friend"]);
  	console.log(data.friend);

  	//var user = {"latitude":35.7749290,"longitude":-118.4194160};
  	//var friend = {"latitude":39.7749290,"longitude":-126.4194160};

  	//var restaurants = map_model.giveRestaurants(user,friend);
	
  	var output={name:"yo"};
  	res.send(JSON.stringify(output));
  	//res.send(restaurants.toString());
});

module.exports = router;
