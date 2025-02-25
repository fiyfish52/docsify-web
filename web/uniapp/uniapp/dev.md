# 开发手册

> ## css

>>  ### 引入公共css

1. 引入scss

在非`static` 目录下，创建 `myscss.scss` 文件,

在根目录下找到文件 `uni.scss` ,加入

```scss
@import "/static/css/common.scss";
```

__如果在static目录下创建scss文件，则不用单独引入__

> ## 组件



> ## vue

>> ### input

input 中 v-model 和 value 不能同时存在，v-model是动态绑定值到value。

正确写法 `<input placeholder="请输入账单金额"  type="number"  maxlength="8"  v-model="sum" />`
错误写法 `<input placeholder="请输入账单金额"  type="number"  maxlength="8" :value="sum"  v-model="sum" />`

>>  ### 监听器

>>>  #### watch

1. template 对应组件添加 `v-model`

2. vue 引入 watch

```vue
import {ref,watch} from "vue"
```

3. 使用

```vue
watch( sum, (newValue, oldValue) => {
	    jsonData.fee = newValue
	  }
	)
```

>>>  #### watchEffect

```vue
watchEffect(()=>{
    console.log(sum);
})
```

> ## tab



> ## 插件

