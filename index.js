const express = require('express')
let app = express();

var bodyParser = require('body-parser');
var shell = require('shelljs');

app.use(express.static("."));
app.use(bodyParser.json()); 

var HOME_HOME_DIR = shell.pwd() + "/hooks/";
var pathRepositories = "/var/opt/gitlab/git-data/repositories/";
var pathFileHooks = "/opt/gitlab/embedded/service/gitlab-shell/custom_hooks/";


app.get("/", (req,res)=>{
    console.log("get");
    res.sendFile(__dirname + '/index.html');
})

app.post("/", (req,res)=>{
    console.log(req.body);
    var jsonReq = req.body;
    console.log("event_name: " + jsonReq.event_name);
   
    if(jsonReq.event_name == "project_create"){
        var path = jsonReq.path_with_namespace;
        addLinkHookProjectCreated(path);
    }

    res.end("Ok!");
})

app.listen("3000", ()=>{
    console.log("Server is listening on port 3000");
    deployHooks();
})

function deployHooks() {  
    console.log(">>>> DeployHooks...");

    //todo
    //shell.mkdir("-p", pathFileHooks);

    shell.ls('-A', HOME_HOME_DIR).forEach(function (file) {
        console.log("file: " + file);
        var f = file.replace(/.\w+$/,"");
        shell.cp(HOME_HOME_DIR+file, pathFileHooks+f);
        shell.chmod(755 ,pathFileHooks+f);        
    });
    
    check(pathFileHooks);
}

function addLinkHookProjectCreated(pathProject) {
    console.log(">>>> Add link to pathProject: " + pathProject);

    var dest = pathRepositories + pathProject + ".git"

    //todo
    //shell.mkdir("-p", dest);
        
    shell.ln("-sf", pathFileHooks, dest+"/custom_hooks");
    
    check(dest+"/custom_hooks/");
}

function check(path) {
    console.log("Checking files in : " + path)
    shell.ls('-A', path).forEach(function (file) {
        console.log("file: " + file)
    });
}

