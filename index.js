var express = require('express')
var app = express();

app.use(express.json());

app.post("/", (req,res)=>{
    console.log(req.params)
    console.log(req.body)
    console.log('request =' + JSON.stringify(req.body))
    res.end('Ok');
})

app.listen("3000", ()=>{
    console.log("Server is listening on port 3000")
})
