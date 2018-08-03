const express = require('express')
let app = express();

app.configure(function(){
   app.use(express.static("."));
   app.use(express.bodyParser());
   app.use(express.methodOverride());
 });

app.get("/", (req,res)=>{
    res.sendFile(__dirname + '/index.html')
})

app.post("/", (req,res)=>{
    console.log(req.body)
    console.log(req.params)
})

app.listen("3000", ()=>{
    console.log("Server is listening on port 3000")
})
