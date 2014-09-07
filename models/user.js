
var mongoose = require('mongoose');

var userschema = mongoose.Schema({
	name:String,
	fbid:String,
	appleid:String
});

module.exports = mongoose.model('users',userschema);