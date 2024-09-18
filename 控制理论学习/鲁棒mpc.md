# 鲁棒mpc

[不确定系统的鲁棒与随机模型预测控制算法比较研究 (aas.net.cn)](http://www.aas.net.cn/article/id/19074)

鲁棒mpc主要分为这两类

## 1 Min-max RMPC

## 2 Tube RMPC

​	其基本思想是通过某种控制率将系统的状态 xk+j 控制在一个可以叫做 Tube 的集合 Xk+j 中, 这个 Tube 集 合为系统约束 X 的子集, 然后将整个 Tube 引导至一个希望的位置. 这种对于 Tube 的操作让人们可以直接处理不确定性所带来的对于系统动态和约束的影响. 此算法的一大优势是可以将系统确定部分和不确定部分分离, 使得控制器可以将很多工作离线计算完成, 这个特点使基于 Tube 的算法得到广泛发展和应用.

​	本文讨论三种典型的基于 Tube 的 RMPC 算法 : 基于 Rigid tube (RT) 的 RMPC, 基于 Homethetic tube (HT) 的 RMPC和基于 Parameterized tube (PT) 的 RMPC.

