var express = require('express')
  , app = express.createServer();

app.use(express.bodyParser());

app.post('/', function(request, response){
  console.log(req.params)
  console.log(req.body)
  console.log('request =' + JSON.stringify(req.body))
  res.end('Ok');
});

app.listen("3000", ()=>{
    console.log("Server is listening on port 3000")
})
