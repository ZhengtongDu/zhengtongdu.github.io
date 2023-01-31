---
layout: post
title: Solutions_to_GAMES101_Assignments
date: 2023-01-31 19:11 +0800
tags: ["Learning Notes", "GAMES101", "Solution"]
toc: true
---

> 记录一下每个Assignment的设计思路，以及用到的知识

## Assignment 01 构建投影矩阵

### 任务要求

给定三维空间中的三个点$v_0(2.0, 0.0, -2.0), v_1(0.0, 2.0, -2.0), v_2(-2.0, 0.0, -2.0)$，由其组成三角形线框。

- 构建旋转矩阵，实现当输入"A"和"D"的时候，三角形将绕z轴旋转（Bonus: 将绕z轴旋转改为绕任意过原点的轴旋转）；
- 构建透视投影矩阵。

### 知识点1：旋转矩阵

完成这次作业首先需要考虑在齐次坐标的框架下如何构造旋转矩阵，以及如何构造透视投影矩阵。

对于第一个问题，构造旋转矩阵，在讲义中提到过，齐次坐标系中物体绕z轴旋转的矩阵形式如下：

$$
    \mathbf{R}_z(\alpha)=
    \begin{pmatrix}\cos\alpha & -\sin\alpha & 0 & 0 \\ \sin\alpha & \cos\alpha & 0 & 0 \\ 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 1\end{pmatrix}
$$

对附加问题，对任意过原点轴旋转，可以参见讲义中提到的Rodrigues旋转公式，绕过原点且方向为$\mathbf{n}$的轴，逆时针旋转$\alpha$的结果是

$$
\mathbf{R}(\mathbf{n}, \alpha) = \cos(\alpha) \mathbf{I} + (1-\cos(\alpha))\mathbf{n}\mathbf{n}^\mathrm{T} + \sin \alpha     \begin{pmatrix}0 & -n_z & n_y \\ n_z & 0 & -n_x \\  -n_y & n_x & 0\end{pmatrix}
$$

由于代码框架中的坐标系是齐次坐标系，因此还需要额外补充一个维度的结果。

### 知识点2：透视投影矩阵

透视投影矩阵由两部分组成：

$$
\mathbf{M}_{persp}
 =
\mathbf{M}_{othro}
\mathbf{M}_{persp\rightarrow ortho}
$$

对于第一个部分，将透视投影变换为正交投影的矩阵，只需要按讲义中的方法处理即可：

$$
\mathbf{M}_{persp\rightarrow ortho}
 =
\begin{pmatrix}
n & 0 & 0 & 0 \\
0 & n & 0 & 0 \\
0 & 0 & n+f & -nf\\
0 & 0 & 1 & 0
\end{pmatrix}
$$

对于正交矩阵，实际上就是将近视口的图像收缩到标准画框大小的缩放变换矩阵，注意代码框架中给的

### 其他需要注意的地方

由于课程提供的代码框架与课堂介绍的代码框架不完全相同，差别主要在于视口的位置是不一样的。在课上，老师介绍的

## Assignment 02 光栅化+Z-buffering
