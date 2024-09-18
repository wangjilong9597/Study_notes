# YOLOv5学习与部署应用

1.ubuntu部署

1.1搭建python环境

1.2部署cude

1.3

## 1.Anaconda3

Anaconda 是 Python 的一个出色的集成开发工具集，包括了Python解释器、conda包管理器、以及众多集成好的数学科学库（numpy/pandas/matplotlib/scipy/sk-learn 等等）因此非常适合于对 python 有数据处理需求的工程师与学生使用，可以减少因包依赖导致的库下载失败而浪费时间。

#### ubuntu下使用Anaconda3

cd 到Anaconda安装目录的bin目录下，输入命令：

```
source activate
```

若要退出终端，输入命令：

```cmd
source deactivate

```

如果觉得如果觉得默认开启（base）环境有点不爽，可输入以下命令改回常规情况：开启（base）环境有点不爽，可输入以下命令改回常规情况：

```
conda config --set auto_activate_base false
```



## 2.CUDA与CUDNN

CUDA是GPU深度学习的运行库，那么cuDNN就是训练加速工具，两者要相互配合使用，所以一般机器学习需要训练引擎(tensorflow-gpu) + CUDA + cuDNN使用。想不安装cuDNN是不可以的，而且cuDNN版本要和CUDA版本相互搭配。

## 3.pytoch