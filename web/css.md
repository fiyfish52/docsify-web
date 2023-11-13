# css

## 两个div 内部div处于外部div最底下

```css
#CSS
.1 {position:relative;}
.2 {position:absolute;left;0;bottom:0;}
#HTML
<div class="1">
  <div class="2"></div>
</div>
```

## 居中

x轴移动-50% `transform:translate(-50%,0)`

```css
    .main {
        position: absolute;
        width: 700px;
        height: 500px;
        background: pink;
        left: 50%;    //起始是在body中，横向距左50%的位置
        top:50%;      //起始是在body中，纵向距上50%的位置，这个点相当于body的中心点，div的左上角的定位
        transform:translate(-50%,-50%);//水平、垂直都居中,也可以写成下面的方式
    }
```

## inline-block 上对齐

```css
vertical-align:top;
```
