http = require "http"
shelljs=require "shelljs"
crypto = require "crypto"

http.createServer (request, response)->
  signBlob = (key, blob) ->
    return 'sha1=' + crypto.createHmac'sha1', key
      .update blob
      .digest 'hex'

  secretHeader = request.headers['x-hub-signature']
  key = 'yan881224'
  statusCode = 505
  result = 
    success:false
    errMsg: ''
  
  if secretHeader? and signBlob(key, secretHeader)
    statusCode = 401
    result = {
      success:false
      errMsg: 'verify failed'
    }
  else
    currentDir = ''+shelljs.pwd()
    hexoPostsDir = "#{currentDir}/../source/_posts"
    hexoDir = "#{currentDir}/../"

    #pull posts
    shelljs.cd hexoPostsDir
    pullCmd = shelljs.exec "ls & git pull origin master "  

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
        statusCode = 503
        result = 
          success: false
          errMsg: 'hexo generage failed:'+hexoCmd.output
      else
        console.log "hexo generate successed!"
        statusCode = 200
        result = 
          success: true
          errMsg: ''
    else
      console.log "pull posts failed"
      statusCode = 505
      result = 
        success: false
        errMsg: "pull posts failed:"+pullCmd.output

    shelljs.cd currentDir

    response.writeHead(statusCode, {"Content-Type": "application/json"});
    response.end result
  return
.listen 8888
