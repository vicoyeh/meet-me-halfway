var apn = require('apn');


var model = function() {

	return  {

		pushTo : function(id,name) {
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
	        // note.payload = {'messageFrom': 'Caroline'};
	        note.setAlertText("Hello, from node-apn!");
	        

	        apnConnection.pushNotification(note, ["<30829bc2 34cfc1ec e6f6ad33 70dee3b6 b00e8b2c a41ca1ca a32cb10b ad7ba6dc>"]);
		}
	}

}

module.exports = model;