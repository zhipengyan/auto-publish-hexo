# auto-publish-hexo
利用git webhooks 自动发布hexo文章
###使用方法
####1.install
```
cd hexo安装路径
git clone https://github.com/zhipengyan/auto-publish-hexo<br/>
cd auto-publish-hexo
npm install
```

####2.打开目录下的config.json进行修改
```json
{
     "time_zone": "Asia/Shanghai", //所在时区，在log中显示时间了，vps一般不是本地时区<br/>
     "webhook_secret": "your secret", //github webhooks设置的secret<br/>
     "nodejs_version": "0.12", //使用的nodejs的版本<br/>
     "path": { //如果hexo的配置为默认的话不用修改下面的<br/>
       "hexo_path": "../", //hexo目录相对路径<br/>
       "hexo_source_path": "../source" //hexo source目录的相对路径，也就是文章目录<br/>
     },<br/>
     "listen_port": 8888 //监听的端口<br/>
}
```

####3.使用npm start或者node index.js运行

