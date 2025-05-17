# LivePortrait

## 说明

数字人



## 源码

```
https://github.com/KwaiVGI/LivePortrait
```



## 工程位置

```
conda activate LivePortrait
cd D:\zhanglp\project\Ollama\LivePortrait
```



## 启动ui页面

```
python app.py
```

## 使用命令生成

```
# source input is an image
python inference.py -s assets/examples/source/s9.jpg -d assets/examples/driving/d0.mp4
# source input is a video ✨
python inference.py -s assets/examples/source/s13.mp4 -d assets/examples/driving/d0.mp4
# more options to see
python inference.py -h
```

