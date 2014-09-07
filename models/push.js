var apn = require('apn');

//setup
var options = { };
var apnConnection = new apn.Connection({ gateway:'gateway.sandbox.push.apple.com' });



var model = function() {

	return  {

		pushTo : function(id,name) {
			var myDevice = new apn.Device(id);

			var note = new apn.Notification();
			note.expiry = Math.floor(Date.now() / 1000) + 3600; // Expires 1 hour from now.
			note.badge = 3;
			note.sound = "ping.aiff";
			note.alert = "\uD83D\uDCE7 \u2709 You have a new invitation";
			note.payload = {'messageFrom': "Tom"};

			console.log("HI");

			apnConnection.pushNotification(note, myDevice);
		}
	}

}

module.exports = model;