
var mongoose = require('mongoose');

module.exports = mongoose.model('User',{
	id: String,
	email: String,
	firstName: String,
	lastName: String
});