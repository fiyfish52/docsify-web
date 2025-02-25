# svn

## SVN标记字母含义

| 标记 | 含义              | 说明                               |
| ---- | ----------------- | ---------------------------------- |
| A    | add               | 新增                               |
| C    | conflict          | 冲突                               |
| D    | delete            | 删除                               |
| M    | modify            | 本地已经修改                       |
| G    | modify and merGed | 本地文件修改并且和服务器的进行合并 |
| U    | update            | 从服务器更新                       |
| R    | replace           | 从服务器替换                       |
| I    | ignored           | 忽略                               |


## 分支合并 Merge

### 解决冲突

```vim
Postpone（推迟）：暂时不处理冲突，先将其标记为未解决状态，以便日后再次进行处理。
Accept base（接受基础版本）：使用服务器上的基础版本，放弃本地修改，将其标记为已解决状态。
Accept incoming（接受服务器版本）：使用服务器上的版本，放弃本地修改，将其标记为已解决状态。
Reject incoming（拒绝服务器版本）：拒绝服务器上的版本，保留本地修改，将其标记为已解决状态。
Accept incoming for conflicts（为冲突接受服务器版本）：使用服务器上的版本解决冲突，将其标记为已解决状态。
Reject conflicts（拒绝冲突）：拒绝解决冲突，保留本地修改，将其标记为已解决状态。
```

## 分支开发步骤：

>1. 创建分支

tortoiseSVN上：在svn创建路径，并且拷贝主干版本到该路径，同时需要记录下主干版本的版本号：可通过showlog进行查看；  
>2. 切换

 eclipse 切换资源库：（一定不要用share project，这个玩意儿仅限第一次导入项目到资源库中）
如果本地已经连接过svn：在项目上，右键------》team------》切换；注意切换回覆盖掉本地代码，注意先要提交哦；防止代码丢失；
如果本地没有连接过svn；只能是checkout或者拷贝其他人的项目；
这里就完成了svn路径的转换：由主干转到了支杆  
>3. 分支开发

 开发枝干；注意要经常将主干的代码合到本地（合代码详见下一步）；  
>4. 代码合并

合并前要保证本地没有任何未提交的记录，否则操作不了合并；  
合并代码的过程发生在本地；合并完成后需要提交才能同步到主干合到支干上：

eclipse 确定连接的是支干，若不是，请看第二步；

选中要合并的文件或者文件夹（java文件或者package）------》右键------》Team------》合并------》选择merge a range of revisions,左下角的perform pre-merge best practices checks作用:

选中后会做合并前的文件检查，最好选中,------》next------》填写Merge from（点击右边select来确定位置）这里填主干的路径；路径的填写仿照select按钮选择出来的路径； 

Revisions有两个选项：

1，all eligible revisions（所有符合条件的修正，即与当前资源库不同的所有更改）

2，select revisions on next page(在下个页面选择要使用的主干上的版本)------》NEXT------》

这一步为：select the options 即选择合并时队医有冲突的文件的处理方式：
一：prompt me for each conflict and let me decide:表示当遇到冲突的时候，弹出框来提示，需要手动选择处理方式，处理方式包括：			
1. Mark as conflicted, i will deal with it later（添加冲突标记，稍后自己手动处理）
2. Resolve the conflict by using my version of the file（使用本地文件覆盖，未测试过）
3. Resolve the conflict by using the incoming version of the file（使用目标资源库版本覆盖）
4. Let me edit the file with coflict markers inserted（手动编辑已经插入冲突标记的文件）
5. Launch a graphical conflict resolution editor（启动图形冲突解决编辑器，就是与资源库进行		比对）

二：mark conflicts ,let me resolve them later(标记冲突，稍后自己解决)

两种方式都可以，建议选择第二种，合并完成后一起解决冲突；

左下角depth：选择Working copy；表示选中的该路径的所有文件和子文件
------》finish；

支干合并到主干，同上；

合并到本地后，如果想恢复，直接右键------》Team------》还原；即可；