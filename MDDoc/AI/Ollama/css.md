# CSS

## 内边框

```css
box-sizing: border-box;
border: 1px solid #333;
```

## 外边框

```css
border: 1px solid #333;
```

## 居中

### flex

```css
.container{
		width:100vw;
		height:80vh;
		display: flex;
		flex-direction: row;//主轴方向
		justify-content: center; // 主轴居中
		align-items: center;//交叉轴居中
	.pic,.video{
		width:100px;
		height:100px;
		border: 1px solid #eee;
	}
}
```

