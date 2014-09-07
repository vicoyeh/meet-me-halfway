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
var login = require('./routes/login');


//db setup #################################
var dbConfig = require('./db');
var mongoose = require('mongoose');
var User = require('./models/user.js');

// // Connect to DB
mongoose.connect(dbConfig.url);
// login.setMongoose(mongoose);

var db = mongoose.connection;

db.once('open', function callback () {
  console.log("connected to database");
});

// mongoose.find(function (err, kittens) {
//   if (err) return console.error(err);
//   console.log(kittens)
// })

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');


app.get('/login',function(req,res){
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



        // // Connect to DB
        mongoose.connect(dbConfig.url);

        console.log("hereddd");

        User.find({fbid:userid}, function(err,data) {
            console.log("here");
            if (err)
              return console.error(err);
            if (!data) {
                console.log("here");
                var newuser = new User({name:usrname,fbid:usrfbid,appleid:usrappleid});
                newuser.save();
            }
        });  


})


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
app.use('/request',account);
//app.use('/login',login);

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
