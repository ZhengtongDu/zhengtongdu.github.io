---
layout: post
title: Computational_Geometry_notes_01
date: 2023-01-14 23:49 +0800
tags: ["learning", "Computational Geometry"]
toc: true
---

## Chapter 09 Delaunay Triangulations

> Used for height interpolation

### Introduction



### Triangulations of Planar Point Sets

#### The Definition of Triangulation

令$P := \{p_1, p_2, \dots, p_n\}$为平面上的一组点集，我们首先定义 _最大平面细分_。

$P$的平面细分$\mathcal{S}$是一个平面图，顶点为$P$的所有点，边为互不相交的线段，由于$P$包含的点是有限个，自然平面细分的边数也存在上限。我们记包含最多边的细分为最大平面细分$\mathcal{S_0}$，此时任意一条由$P$上两点连成，且不在$\mathcal{S_0}$中的线段都与$\mathcal{S_0}$中的某条线段相交。由欧拉定律，$\mathcal{S_0}$的边数$n_e$取决于$P$中的点数$n$和$P$的凸包$\mathrm{CH}(P)$中包含的点数$k$，并满足如下关系式：

$$
    n_e = 3n - 3 - k.
$$

在这样的定义下，我们还可以得知：$\mathcal{S_0}$构成的平面图中，最小单位的多边形结构都是三角形（否则，必然可以添加更多线段到$\mathcal{S_0}$中，矛盾！），因此，我们也称由$P$中点生成的最大平面细分为$P$的 _三角剖分_，记作$\mathcal{T}$。同样，$\mathcal{T}$中包含的三角形个数$n_t$也由$P$中的点数$n$和$P$的凸包$\mathrm{CH}(P)$中包含的点数$k$确定，并满足如下关系式：

$$
    n_t = 2n - 2 - k.
$$

#### Angle-optimal/Legal Triangulation



### The Delaunay Triangulation

### Computing the Delaunay Triangulation

### The Analysis

