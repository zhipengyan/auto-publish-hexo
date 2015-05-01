// Generated by CoffeeScript 1.7.1
(function() {
  var http, shelljs;

  http = require("http");

  shelljs = require("shelljs");

  http.createServer(function(request, response) {
    var currentDir, hexoCmd, hexoDir, hexoPostsDir, nvmCmd, pullCmd, result;
    response.writeHead(200, {
      "Content-Type": "text/plain"
    });
    if (request.body.SECRET_TOKEN === 'yan881224') {
      response.write('yan881224');
      response.end();
    } else {
      currentDir = '' + shelljs.pwd();
      hexoPostsDir = "" + currentDir + "/../source/_posts";
      hexoDir = "" + currentDir + "/../";
      shelljs.cd(hexoPostsDir);
      pullCmd = shelljs.exec("ls & git pull origin master ");
      result = false;
      if (pullCmd.code === 0) {
        console.log("pull successed!");
        if (!(shelljs.which('node'))) {
          nvmCmd = shelljs.exec("nvm use 0.12");
        }
        shelljs.cd(hexoDir);
        hexoCmd = shelljs.exec("hexo clean & hexo generate");
        if (hexoCmd.code !== 0) {
          console.log("hexo generate failed!");
          result = false;
        } else {
          console.log("hexo generate successed!");
        }
        result = true;
      } else {
        console.log("pull posts failed");
        result = false;
      }
      shelljs.cd(currentDir);
      response.write('' + result);
      response.end();
    }
  }).listen(8888);

}).call(this);
