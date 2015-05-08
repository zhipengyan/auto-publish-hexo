http = require "http"
shelljs=require "shelljs"
crypto = require "crypto"
bl = require 'bl'
config = require './config'

key = config.webhook_secret
currentDir = ''+shelljs.pwd()
hexoSourceDir = "#{currentDir}/#{config.path.hexo_source_path}"
hexoDir = "#{currentDir}/#{config.path.hexo_path}"
nodeVersion = config.nodejs_version
listenPort = config.listen_port

http.createServer (request, response)->
  request.pipe bl (err, blob)->
      signBlob = (key) ->
        return 'sha1=' + crypto.createHmac 'sha1', key
          .update blob 
          .digest 'hex'

      sig = request.headers['x-hub-signature']
      event = request.headers['x-github-event']
      id = request.headers['x-github-delivery']
      statusCode = 400
      result = 
        success:false
        errMsg: ''
      
      if not (sig  and id and event and signBlob(key) is sig+'')
        statusCode = 401
        result = {
          success:false
          errMsg: 'vertify failed'
        }
      else

        #pull posts
        shelljs.cd hexoSourceDir
        pullCmd = shelljs.exec "ls & git pull origin master "  

        if pullCmd.code is 0 
          #pull successed!
          console.log "pull successed!"
          
          #active node
          if not (shelljs.which 'node')
            if shelljs.which 'nvm'
              nvmCmd = shelljs.exec "nvm use #{nodeVersion}"

          if shelljs.which 'node'
            shelljs.cd hexoDir
            hexoCmd = shelljs.exec "hexo clean & hexo generate"
            if hexoCmd.code isnt 0
              datetime = new Date()
              console.log datetime.getTime()+" hexo generate failed!"
              statusCode = 500
              result = 
                success: false
                errMsg: "hexo generage failed:"+hexoCmd.output
            else
              console.log "hexo generate successed!"
              statusCode = 200
              result = 
                success: true
                errMsg: ''
                msg: hexoCmd.output
          else
            result = 
              success: false
              errMsg: "can't use node, check it!"
        else
          console.log "pull posts failed"
          statusCode = 500
          result = 
            success: false
            errMsg: "pull posts failed:"+pullCmd.output

      shelljs.cd currentDir

      response.writeHead statusCode, {"Content-Type": "application/json"}
      response.end JSON.stringify result
      return
  return
.listen listenPort
