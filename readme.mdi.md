# user.tax

* [chatroom](https://user-tax.zulipchat.com)
* [twitter](https://twitter.com/_user_tax)

brotli size `> ./.include/brotli.md` 

# 请求者
parseInt(+new Date())
发送请求
  响应自己的 id

发送获取信号
  发送者 id 请求 id

等待 30 毫秒之后

如果没收到响应，那么开始网络请求

并认定自己是领导者

# 响应者

收到信号

如果自己是领导者，响应

  否则
    等待 10 毫秒
      检查收件箱
        如果存在大于等于 10 毫秒没响应的内容
          认定自己的领导者
            响应内容
      收到信号
        从收件箱中删除内容
