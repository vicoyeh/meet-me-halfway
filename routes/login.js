var express = require('express');
var router = express.Router();

var dbConfig = require('../db');
var mongoose = require('mongoose');
var User = require('../models/user.js');



/* GET home page. */
router.post('/', function(req, res) {

 		console.log("Received req: login");
	    // //parse req object
        var arr = Object.keys(req.body);
        var str = arr[0];
        console.log(str);
        var data = JSON.parse(str);
        console.log(data);
        var usrname = data.name;
        var usrfbid = data.fbid;
        var usrappleid = data.appleid;



        // // Connect to DB
        mongoose.connect(dbConfig.url);

        var db = mongoose.connection;

		db.once('open', function callback () {
		  console.log("connected to database");
		});

        console.log("hereddd");

        User.find({fbid:userid}, function(err,data) {
        	console.log("here");
            if (err)
              return console.error(err);
            if (!data) {
            	console.log("here");
            	var newuser = new User({name:usrname,fbid:usrfbid,appleid:usrappleid});
            	newuser.save();
            }
        });  

});

module.exports.setMongoose = function(m){
	mongoose = m;
};

module.exports = router;