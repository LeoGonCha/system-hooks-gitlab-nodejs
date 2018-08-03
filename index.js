const express = require('express')
let app = express();

app.use(express.json());

app.post("/", (req,res)=>{
    console.log(req.params)
    console.log(req.body)
    res.end('Ok');
})

app.listen("3000", ()=>{
    console.log("Server is listening on port 3000")
})
