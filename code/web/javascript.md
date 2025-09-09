### 修改后关闭窗口提示

```html
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
</head>
<body>


<input id="test" value="1">

<script lang="typescript/js">
    /*
        这样关闭和刷新窗口的时候都会提示
        遇到问题：
            1、如果打开界面没有任何操作，包括单机界面，是不会出发一下事件的
            2、修改提示文字好像没有起作用。
    */
    // 监听所有点击事件，并在控制台打印被点击的元素
    document.addEventListener('click', (e) => {
        console.log(e.target);
    });

    setTimeout(function(){

        document.getElementById("test").value=10;

        document.getElementById("test").value=11;
// 定义我们要点击的坐标
        const x = 200;
        const y = 200;

// 获取指定坐标上的元素，并触发点击事件
        document.elementFromPoint(x, y).click();


        window.isCloseHint = true;

    },100);
    //初始化关闭
    // window.addEventListener("beforeunload", function(e) {
    //     if (window.isCloseHint) {
    //         var confirmationMessage = "要记得保存！你确定要离开我吗？";
    //         // (e || window.event).returnValue = confirmationMessage; // 兼容 Gecko + IE
    //         e.returnValue = confirmationMessage;
    //         return confirmationMessage; // 兼容 Gecko + Webkit, Safari, Chrome
    //     }
    //
    //
    // });
    window.addEventListener('beforeunload', function (e) {
        e.preventDefault(); // 阻止默认行为
        e.returnValue = '123'; // 显示默认提示框
    });
</script>
</body>
</html>
```

