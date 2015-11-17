# auto-publish-hexo
利用git webhooks 自动发布hexo文章
###使用方法
####1.install
```
cd hexo安装路径
git clone https://github.com/zhipengyan/auto-publish-hexo
cd auto-publish-hexo
npm install
```

####2.打开目录下的config.json进行修改
```javascript
{
     "time_zone": "Asia/Shanghai",           //所在时区，在log中显示时间了，vps一般不是本地时区
     "webhook_secret": "your secret",        //github webhooks设置的secret
     "nodejs_version": "0.12",               //使用的nodejs的版本
     "path": {                               //如果hexo的配置为默认的话不用修改下面的
       "hexo_path": "../",                   //hexo目录相对路径
       "hexo_source_path": "../source"       //hexo source目录的相对路径，也就是文章目录
     },
     "listen_port": 8888                     //监听的端口
}
```

####3.使用npm start或者node index.js运行

