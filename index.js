const express = require('express')
let app = express();

app.use(express.static("."));
app.use(express.bodyParser());

var shell = require('shelljs');

app.get("/", (req,res)=>{
    shell.ls('-A', '.').forEach(function (file) {
    res.sendFile(__dirname + '/index.html')
})

app.post("/", (req,res)=>{
    console.log(req.body)
    console.log(req.params)
})

app.listen("3000", ()=>{
    console.log("Server is listening on port 3000")
})
