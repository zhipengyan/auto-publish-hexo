http = require "http"
shelljs=require "shelljs"

http.createServer (request, response)->
  response.writeHead 200,{"Content-Type":"text/plain"}
  if request.body.SECRET_TOKEN is 'yan881224'
    response.write 'yan881224'
    response.end()
  else
    currentDir = ''+shelljs.pwd()
    hexoPostsDir = "#{currentDir}/../source/_posts"
    hexoDir = "#{currentDir}/../"

    #pull posts
    shelljs.cd hexoPostsDir
    pullCmd = shelljs.exec "ls & git pull origin master "  
    result = false

    if pullCmd.code is 0 
      #pull successed!
      console.log "pull successed!"
      
      #open node, if you are not using nvm please skip this step
      if not (shelljs.which 'node')
        nvmCmd = shelljs.exec "nvm use 0.12"

      shelljs.cd hexoDir
      hexoCmd = shelljs.exec "hexo clean & hexo generate"
      if hexoCmd.code isnt 0
        console.log "hexo generate failed!"
        result = false
      else
        console.log "hexo generate successed!"
      result = true
    else
      console.log "pull posts failed"
      result = false

    shelljs.cd currentDir
    response.write ''+result
    response.end()
  return
.listen 8888
