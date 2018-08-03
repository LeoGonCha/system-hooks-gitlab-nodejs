const express = require('express')
let app = express();

var bodyParser = require('body-parser');
var shell = require('shelljs');

app.use(express.static("."));
app.use(bodyParser.json()); 


app.get("/", (req,res)=>{
    shell.ls('-A', '.').forEach(function (file) {
        console.log(file)
    });
    res.sendFile(__dirname + '/index.html');
})

app.post("/", (req,res)=>{
    console.log(req.body);
    console.log(req.params);
    res.end("Ok!");
})

app.listen("3000", ()=>{
    console.log("Server is listening on port 3000");
})
