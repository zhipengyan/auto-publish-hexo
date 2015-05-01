http = require "http"
shelljs=require "shelljs"
crypto = require "crypto"
getRawBody = require "raw-body"


http.createServer (request, response)->
  tempstr
  getRawBody request, {
        length: req.headers['content-length']
        limit: '1mb'
        encoding: 'utf-8'
    }, (err, blob)->
      console.log 'init getRawBody'
      signBlob = (key) ->
        return 'sha1=' + crypto.createHmac 'sha1', key
          .update blob 
          .digest 'hex'

      secretHeader = request.headers['x-hub-signature']
      key = 'yan881224'
      statusCode = 505
      tempstr = signBlob(key, blob)
      result = 
        success:false
        errMsg: ''
      
      currentDir = ''+shelljs.pwd()
      hexoPostsDir = "#{currentDir}/../source/_posts"
      hexoDir = "#{currentDir}/../"

      if not (secretHeader and signBlob(key) is secretHeader+'')
        statusCode = 401
        result = {
          success:false
          errMsg: 'vertify failed'
        }
      else

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
      response.end JSON.stringify(secretHeader + '---'+ signBlob(key))
      next()
      return
    response.writeHead(200, {"Content-Type": "application/json"});
    response.end JSON.stringify(tempstr + '---')
  return
.listen 8888
