var apn = require('apn');

console.log("Hello");

var options = {cert: 'cert.pem', key: 'key.pem', passphrase: 'password', production: false };

var apnConnection = new apn.Connection(options);



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

var tokens = ["<30829bc2 34cfc1ec e6f6ad33 70dee3b6 b00e8b2c a41ca1ca a32cb10b ad7ba6dc>"];

var note = new apn.notification();
note.setAlertText("Hello, from node-apn!");
note.badge = 1;

apnConnection.pushNotification(note, tokens);

console.log("Done: " + apnConnection);




