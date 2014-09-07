
var mongoose = require('mongoose');

module.exports = mongoose.model('User',{
	fbid: String,
	appleid: String,
	email: String,
	firstName: String,
	lastName: String
});