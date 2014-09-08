var express = require('express');
var bodyParser = require('body-parser');
var router = express.Router();

var map_model = require('../models/maps')();
var apn = require('apn');


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



/////////////////////push notification
          

            var options = {cert:'./cert.pem',key:'./key.pem',  production:false,passphrase:'password' };
            var apnConnection = new apn.Connection(options);


 

                
       
            var note = new apn.Notification();
          
            // note.expiry = Math.floor(Date.now() / 1000) + 3600; // Expires 1 hour from now.
            // note.badge = 3;
            // note.sound = "ping.aiff";
            // note.alert = "\uD83D\uDCE7 \u2709 You have a new message";
            note.payload = {'name': 'Kevin', 'fbid':'292139219394' };
            var text = "Kevin sent you a request for food!"
            note.setAlertText(text);
           
            apnConnection.pushNotification(note, ["<30829bc2 34cfc1ec e6f6ad33 70dee3b6 b00e8b2c a41ca1ca a32cb10b ad7ba6dc>"]);



/////////////
  	var restaurants = [];

  	//test data
  	//var user = {"latitude":35.7749290,"longitude":-118.4194160};
  	//var friend = {"latitude":39.7749290,"longitude":-126.4194160};

  	map_model.giveRestaurants(user,friend,function(restaurants){
		  res.send(restaurants);
  	});

  	//res.send(restaurants.toString());
});

module.exports = router;
