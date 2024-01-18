# 全局水印

?> 需求：给所有除登录以外的页面加上水印。水印信息为姓名+手机号（这部分信息可以从后端获取动态展示，也可以静态给水印赋值内容）下面基于这两种情况分别给出不同方法。

## 基础配置

### 在src下创建目录utils

### 在utils目录创建一个waterMark.js文件

#### waterMark.js文件

```js
let watermark = {}
 
let setWatermark = (str) => {
  let id = '1.23452384164.123412416';
 
  if (document.getElementById(id) !== null) {
    document.body.removeChild(document.getElementById(id));
  }
 
  //创建一个画布
  let can = document.createElement('canvas');
  //设置画布的长宽
  can.width = 120;
  can.height = 120;
 
  let cans = can.getContext('2d');
  //旋转角度
  cans.rotate(-15 * Math.PI / 180);
  cans.font = '18px Vedana';
  //设置填充绘画的颜色、渐变或者模式
  cans.fillStyle = 'rgba(200, 200, 200, 0.40)';
  //设置文本内容的当前对齐方式
  cans.textAlign = 'left';
  //设置在绘制文本时使用的当前文本基线
  cans.textBaseline = 'Middle';
  //在画布上绘制填色的文本（输出的文本，开始绘制文本的X坐标位置，开始绘制文本的Y坐标位置）
  cans.fillText(str, can.width / 8, can.height / 2);
 
  let div = document.createElement('div');
  div.id = id;
  div.style.pointerEvents = 'none';
  div.style.top = '30px';
  div.style.left = '0px';
  div.style.position = 'fixed';
  div.style.zIndex = '100000';
  div.style.width = document.documentElement.clientWidth + 'px';
  div.style.height = document.documentElement.clientHeight + 'px';
  div.style.background = 'url(' + can.toDataURL('image/png') + ') left top repeat';
  document.body.appendChild(div);
  return id;
}
 
// 该方法只允许调用一次
watermark.set = (str) => {
  let id = setWatermark(str);
  setInterval(() => {
    if (document.getElementById(id) === null) {
      id = setWatermark(str);
    }
  }, 500);
  window.onresize = () => {
    setWatermark(str);
  };
}
 
export default watermark;
```

## 静态设置水印

?> 如果想要在登录界面也想显示水印，就可在在APP.vue文件中导入waterMark.js文件，在mounted函数中调用warterMark

代码如下：

```js
<script>
    import warterMark from './utils/warterMark.js';
    export default {
        mounted: function() {
            warterMark.set("水印")
        },
    }
</script>
```

?> 如果登录页面不显示水印，则需要在main.js文件中导入warterMark.js文件，route.beforeEach()方法中判断是否为登录页面，最后调用水印方法

代码如下：

```js
import warterMark from './utils/warterMark.js';
  router.afterEach((item) =>{
    if(item.name !== 'login'){
            warterMark.set("水印")
    }    
    })
```

## 动态设置水印

?> 如果我们要用当前用户信息（例如姓名、id、手机号）作为水印内容，而用户信息一般存储在vuex里方便全局调用，那么在APP.vue中的mounted函数很可能获取不到vuex中的用户信息。

?> 解决这个问题可以在main.js文件中使用route.beforeEach()方法中判断是否为登录页面，不是则并在此方法中调用水印方法

### 在login.vue文件获取用户信息，并存入vuex

代码如下：

```js
<script>
    import {mapMutations} from 'vuex'; //引入vuex的方法
    name: "login",
        data() {
            return {
                userCname:'' //用户中文名
                userPhoneNum:'' //用户手机号
            }
        },
       beforeCreate() {
           _this.setUserMassage() //接收数据的方法
       }，
      method:{
        login(){
          var _this = this
          _this.axios.get('//接口地址', {
             params: {
                      参数传递
                            }
               }).then((res) => {
               console.log(res.data)
                _this.setUserMassage({ //
                userPhoneNum:用户手机号,
                userCname:用户中文名,
               });
              }).catch(function (err) {
              
          })
      
  },
      ...mapMutations('home', ['setUserMassage']),//存入vuex
      }
```

### 在store中新建home.js文件

代码如下：

```js
const state = {
 
userMassage:{},
 
}
 
const getters = {
 
}
 
const actions = {
 
}
 
const mutations = {
 
setUserMassage(state,userMassage){
 
      state.userMassage=userMassage
 
},
 
}
 
export default {
 
namespaced: true,
 
state,
 
getters,
 
actions,
 
mutations
 
}
```

### 在main.js文件中引用水印方法

代码如下：

```js
router.afterEach((item) =>{
    //warterMark.set("水印")
    if(item.name !== 'login'){    //判断是否为登录页面
 
warterMark.set(store.state.home.userMassage.userCname+''+store.state.home.userMassage.userPhoneNum)
    }    
    })
```
