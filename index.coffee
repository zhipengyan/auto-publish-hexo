http = require "http"
shelljs=require "shelljs"

http.createServer (request, response)->
  response.writeHead 200,{"Content-Type":"text/plain"}
  currentDir = ''+shelljs.pwd()
  hexoPostsDir = "#{currentDir}/../source/_posts"
  hexoDir = "#{currentDir}/../"

  #pull posts
  pullCmd = shelljs.exec "cd #{hexoPostsDir} & git pull origin master "  

  if pullCmd.code is 0 
    #pull successed!
    console.log "pull successed!"
    
    #open node, if you are not using nvm please skip this step
    if not (shelljs.which 'node')
      nvmCmd = shelljs.exec "nvm use 0.12"
    hexoCmd = shelljs.exec "cd #{hexoDir} & hexo server"
    if hexoCmd.code isnt 0
      console.log "hexo server failed!"
    else
      console.log "hexo server successed!"
  else
    console.log "pull posts failed"

  result = ''+pullCmd.code
  response.write result
  response.end()
  return
.listen 8888
