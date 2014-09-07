var express = require('express');
var bodyParser = require('body-parser');
var router = express.Router();
var pushNotification = require('../models/push');
var apn = require('apn');


router.post('/',[bodyParser.urlencoded(), bodyParser.json()], function(req, res) {
        // res.set('Content-Type','application/json');
        console.log("Received req: account");
        // console.log(req.body);

        // //parse req object
        var arr = Object.keys(req.body);
        var str = arr[0];
        console.log(str);
        var data = JSON.parse(str);
        console.log(data);
        // console.log(data.appleid);
        // console.log(data.username);
        var userid = data.myFBID;
        var friendid = data.theirFBID;

        var username;

        //db setup #################################
        var dbConfig = require('../db');
        var mongoose = require('mongoose');
        var User = require('../models/user.js');

        // // Connect to DB
        mongoose.connect(dbConfig.url);

        // var db = mongoose.connection;
        // db.once('open', function callback () {
        //   console.log("connected to database");
        // });

        User.find({fbid:userid}, function(err,data) {
            if (err)
              return console.error(err);
            if (data) {
              username=data.name;
              console.log(username);
            }
        });


        User.find({fbid:friendid},function(err,data){

            var appleid = data.appleid;

            var options = {cert:'./cert.pem',key:'./key.pem',  production:false,passphrase:'password' };
            var apnConnection = new apn.Connection(options);


            //condition checking
            apnConnection.on('connected', function(){
              console.log("CONNECTED");
                });

            apnConnection.on('error', function(err){
              console.log("ERROR: " + err);
                });

            apnConnection.on('socketError', function(err){
              console.log("ERROR: " + err);
                });

            apnConnection.on('transmissionError', function(err, nfn, dev){
              console.log("ERROR: " + err + " : " + nfn + " : " + dev);
                });

                
       
            var note = new apn.Notification();
          
            // note.expiry = Math.floor(Date.now() / 1000) + 3600; // Expires 1 hour from now.
            // note.badge = 3;
            // note.sound = "ping.aiff";
            // note.alert = "\uD83D\uDCE7 \u2709 You have a new message";
            note.payload = {'messageFrom': username, 'fromID':userid };
            var text = username+" sent you a request for food!"
            note.setAlertText(text);
            

            apnConnection.pushNotification(note, [appleid]);

        });
        
        //pushNotification.pushTo("<30829bc2 34cfc1ec e6f6ad33 70dee3b6 b00e8b2c a41ca1ca a32cb10b ad7ba6dc>","John");
});

module.exports = router;