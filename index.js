const express = require('express')
let app = express();

var bodyParser = require('body-parser');
var shell = require('shelljs');

app.use(express.static("."));
app.use(bodyParser.json()); 


app.get("/", (req,res)=>{
    console.log("get");
    res.sendFile(__dirname + '/index.html');
})

app.post("/", (req,res)=>{
    console.log(req.body);
    if(req.body.event_name == "project_create"){
        console.log("pwd: " + shell.pwd());
    } else {
        console.log("pwd else: " + shell.pwd());
    }
    res.end("Ok!");
})

app.listen("3000", ()=>{
    console.log("Server is listening on port 3000");
})
