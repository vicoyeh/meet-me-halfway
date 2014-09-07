var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res) {

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

	    var dbConfig = require('../db');
        var mongoose = require('mongoose');
        var User = require('../models/user.js');

        // // Connect to DB
        mongoose.connect(dbConfig.url);

        User.find({fbid:userid}, function(err,data) {
            if (err)
              return console.error(err);
            if (!data) {
            	var newuser = new User({name:usrname,fbid:usrfbid,appleid:usrappleid});
            	newuser.save();
            }
        });  

});

module.exports = router;