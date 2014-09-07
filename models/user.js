
var mongoose = require('mongoose');

var userschema = mongoose.Schema({
	fbid: String,
	appleid: String,
	email: String,
	firstName: String,
	lastName: String
});

module.exports = mongoose.model('User',userschema);