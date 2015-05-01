http = require "http"
shelljs=require "shelljs"

http.createServer (request, response)->
  response.writeHead 200,{"Content-Type":"text/plain"}
  #shelljs.cd '~'
  currentDir = ''+shelljs.pwd()
  hexoPostsDir = "#{currentDir}/../"
  result = shelljs.exec "ls #{hexoPostsDir}"  
    .output
  result = ''+result
  response.write result
  response.end()
  return
.listen 8888
