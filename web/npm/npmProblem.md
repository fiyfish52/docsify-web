#  npm problem



## npm 命令

| 操作   | 命令                    | 关联操作                                                     |
| ------ | ----------------------- | ------------------------------------------------------------ |
| 查看源 | npm config get registry | 替换源： npm config set registry=https://registry.npmmirror.com |
|        |                         |                                                              |
|        |                         |                                                              |



## npm install 报错



| 错误                                                  | 方案                                                         |      |
| ----------------------------------------------------- | ------------------------------------------------------------ | ---- |
| `ssh://git@github.com无法连接`                        | git config --global url."https://github.com/".insteadOf "ssh://git@github.com/" |      |
| `unable to connect to github.com`                     | git config --global url."https://".insteadOf git://          |      |
| `OpenSSL SSL_read: Connection was reset, errno 10054` | npm config set registry https://registry.npm.taobao.org      |      |
| `Filename too long（文件名称过长）`                   | git config --global core.longpaths true                      |      |





## vue 前端项目启动报错： `Invalid name`

package.json 中 `name`属性 必须是连续的英文字符串

