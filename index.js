const express = require('express')
let app = express();

var bodyParser = require('body-parser');
var shell = require('shelljs');

app.use(express.static("."));
app.use(bodyParser.json()); 

var HOME_HOME_DIR = shel.pwd() + "/hooks";
var HOOK_DIR = shel.pwd() + "/hooks";


app.get("/", (req,res)=>{
    console.log("get");
    res.sendFile(__dirname + '/index.html');
})

app.post("/", (req,res)=>{
    console.log(req.body);
    var jsonReq = req.body;
    console.log("jsonReq: " + jsonReq);
    console.log("event_name: " + jsonReq.event_name);
    console.log("pwd: " + shell.pwd());
    shell.ls('-A', '*.*').forEach(function (file) {
        console.log(file)
    });
    if(jsonReq.event_name == "project_create"){
        var path = jsonReq.path_with_namespace;
        addHookProjectCreated(path);
    }
    res.end("Ok!");
})

app.listen("3000", ()=>{
    console.log("Server is listening on port 3000");
})

function deployHooks(params) {
/*
    criar dir custom_hooks

move
	gitlab_rest_client.rb -> gitlab_rest_client.rb
	custom_pre_receive -> pre-receive
    custom_update -> update
*/


}

function addHookProjectCreated(pathProject) {
    var pathRepositories = "/var/opt/gitlab/git-data/repositories/";
    var dest = pathRepositories + pathProject + ".git"
  
    console.log("orig: " + HOME_HOME_DIR);
    console.log("dest: " + dest);
    //shell.mv("/hooks/gitlab_rest_client.rb", )

}