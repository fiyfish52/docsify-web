# vue



## 自定义指定 auth

> 定义

`main.js`

```js
Vue.directive('permission', {
  inserted: function(el, binding, vnode) {
    const value = binding.value
    const st = vnode.context.$store
    if (value && value && st) {
      const permission = getPermission()
      if (permission) {
        if (permission.indexOf(value) === -1) {
          el.parentNode.removeChild(el)
        }
      } else {
        el.parentNode.removeChild(el)
      }
    }
  }
})
```

> 用法

```js
 v-auth="{name:operator_add}"
```
