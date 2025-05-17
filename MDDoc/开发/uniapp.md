# uniapp 开发笔记



## 计算属性





## 组件传参 props

[官网]: https://cn.vuejs.org/guide/components/props	"官网api"

```js
const props = defineProps({
	  mode: {
		  type:String,
		  default(){
			  return "selector"
		  }
	  },
	  title: {
		  type:String,
		  default(){
			  return "名称"
		  }
	  },
	  typeRange:{
		  type:[Array , null],
		  default(){
			  return [{
					key: 0,
					name: "日常用品"
				}, {
					key: 1,
					name: "日常用品2"
				}];
		  }
	  },
	  likes: Number
	})
```

 ### 使用props

```js
const props = ...
props.XX
```

## 页面跳转

### 关闭当前页面

适用于再次切换回来需要刷新的页面；

```js
uni.redirectTo({
		url: '/pages/addAccount/addAccount'
	})
```

## 保留当前页面

保留当前页面，跳转到应用内的某个页面，使用`uni.navigateBack`可以返回到原页面。

```
//在起始页面跳转到test.vue页面并传递参数
uni.navigateTo({
	url: 'test?id=1&name=uniapp'
});
```

