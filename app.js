var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');


//routers #################################
//var routes = require('./routes/index');
//var users = require('./routes/users');
var maps = require('./routes/maps');
var account = require('./routes/account');


//db setup #################################
var dbConfig = require('./db');
var mongoose = require('mongoose');
var User = require('./models/user.js');

// // Connect to DB
mongoose.connect(dbConfig.url);

var db = mongoose.connection;

db.once('open', function callback () {
  console.log("connected to database");
});

// mongoose.find(function (err, kittens) {
//   if (err) return console.error(err);
//   console.log(kittens)
// })

var ethan = new User({name: 'Tom'});
ethan.save();
console.log(ethan.name);




var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');


//app use #################################
// uncomment after placing your favicon in /public
//app.use(favicon(__dirname + '/public/favicon.ico'));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

//app.use('/', routes);
//app.use('/users', users);
app.use('/maps', maps);
app.use('/account',account);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
        message: err.message,
        error: {}
    });
});


module.exports = app;
