var express = require('express');
var bodyParser = require('body-parser');
var router = express.Router();


router.post('/',[bodyParser.urlencoded(), bodyParser.json()], function(req, res) {
  res.set('Content-Type','application/json');
  console.log("Received req: account");
  console.log(req.body);

  //parse req object
  var arr = Object.keys(req.body);
  var str = arr[0];
  console.log(str);
  var data = JSON.parse(str);
  console.log(data);
  console.log(data.appleid);
  console.log(data.username);
  
});

module.exports = router;