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

令$P := \{p_1, p_2, \dots, p_n\}$为平面上的一组点集，我们首先定义 _最大平面子细分(maximal planar subdivision)_。

$P$的平面子细分$\mathcal{S}$是一个平面图，顶点为$P$的所有点，边为互不相交的线段，由于$P$包含的点是有限个，自然平面子细分的边数也存在上限。我们记包含最多边的细分为最大平面子细分$\mathcal{S_0}$，此时任意一条由$P$上两点连成，且不在$\mathcal{S_0}$中的线段都与$\mathcal{S_0}$中的某条线段相交。

由欧拉定律，$\mathcal{S_0}$的边数$n_e$取决于$P$中的点数$n$和$P$的凸包$\mathrm{CH}(P)$中包含的点数$k$，并满足如下关系式：

$$
    n_e = 3n - 3 - k.
$$

在这样的定义下，我们还可以得知：$\mathcal{S_0}$构成的平面图中，最小单位的多边形结构都是三角形（否则，必然可以添加更多线段到$\mathcal{S_0}$中，矛盾！），因此，我们也称由$P$中点生成的最大平面子细分为$P$的 _三角剖分(triangulation)_，记作$\mathcal{T}$。

同样，$\mathcal{T}$中包含的三角形个数$n_t$也由$P$中的点数$n$和$P$的凸包$\mathrm{CH}(P)$中包含的点数$k$确定，并满足如下关系式：

$$
    n_t = 2n - 2 - k.
$$

#### Angle-optimal Triangulation

在上述定义下，我们讨论$P$的三角剖分$\mathcal{T}$的性质，假设其中包含$m$个三角形。则$\mathcal{T}$中三角形的角共有$3m$个，将其按升序排列并编号，记为$\alpha_1, \alpha_2, \dots, \alpha_{3m}$，则它们满足对任意的$1\le i < j \le 3m$都有$\alpha_i \le \alpha_j$。我们定义$A(\mathcal{T}) := (\alpha_1, \alpha_2, \dots, \alpha_{3m})$为$\mathcal{T}$的 _角度序列(angle-vector)_
。

令$\mathcal{T'}$为$P$的另一个三角剖分，它的角度序列$A(\mathcal{T'}) := (\alpha'_1, \alpha'_2, \dots, \alpha'_{3m})$。如果存在$i$，$1\le i \le 3m$，满足

$$
    \alpha_j = \alpha'_j,\ \forall j < i,\quad \alpha_i < \alpha'_i.
$$

我们称角度序列$A(\mathcal{T})$比$A(\mathcal{T'})$大，记为$\mathcal{T} > \mathcal{T'}$。

如果一个$P$的三角剖分$\mathcal{T_0}$满足对$P$的任意三角剖分$\mathcal{T}$都有$A(\mathcal{T_0}) \ge \mathcal{T}$，我们就说$\mathcal{T_0}$是$P$的 _角度最优三角剖分(angle-optimal triangulation)_。

#### Way to Construct Angle-optimal Triangulation

如果$P$的三角剖分$\mathcal{T}$中的一条边$e = \overline{p_i p_j}$满足

- $e$不是$\mathrm{CH}(\mathcal{S_0})$上的边；
- 由$e$构成的两个相邻三角形可以拼接成一个凸四边形，另外两点记为$p_l, p_k$。

那么我们可以通过对$\mathcal{T}$删除$\overline{p_ip_j}$并添加$\overline{p_lp_k}$的形式获得不同于$\mathcal{T}$的新的三角剖分$\mathcal{T'}$。显然，两个三角剖分的角度序列中只有6个角发生了变化，它们从$\alpha_1, \alpha_2,\dots, \alpha_6$变成了$\alpha'_1, \alpha'_2,\dots, \alpha'_6$。如果

$$
    \min_{1\le i \le 6} \alpha_i < \min_{1\le j \le 6} \alpha'_j
$$

我们就称边$e = \overline{p_ip_j}$是 _不合规的(illegal)_。之前提到的“删除$\overline{p_ip_j}$并添加$\overline{p_lp_k}$”操作我们称为 _边翻转(edge flip)_

如果一个三角剖分中不存在不合规边，那么我们就说它是 _合规三角剖分(legal triangulation)_。根据这些定义，我们可以得知角度最优三角剖分一定是合规三角剖分。

由于有限点集的三角剖分数量是有限的，加上不合规边可以通过边翻转操作变为合规边，因此我们可以通过不断地检查当前三角剖分是否存在不合规边，并通过边翻转操作改进，最终得到一个合规的三角剖分。具体算法如下：

```c++
Algorithm Legal_Triangulation(T)
// Input: Any triangulation T of a point set P
// Output: A legal triangulation of P
    while(T contains an illegal edge (i, j))
        for(each edge(i, j) is illegal)
            flip(T, p_i, p_j);
    return T
```

事实上，基于泰勒斯定理（见附录）及初等几何的知识，我们不需要对重复比较边翻转前后的六个角大小来判断边是否合规，这可以加速算法的过程。但是即便如此，算法的时间复杂度仍然非常大且难以估计；此外，这一方法的结果是合规的三角剖分，与我们最初问题中期待的角度最优三角剖分仍有一定差距。为了解决上述问题，人们提出了 _Delaunay三角剖分_

### The Delaunay Triangulation

### Computing the Delaunay Triangulation

### The Analysis

### Appendix

#### 泰勒斯定理(Thales's Theorem):

Theorem 9.2 (Thales's Theorem): 令$C$为一个圆，$l$为与$C$相交的一条直线，两个交点分别为$a, b$。$p, q, r, s$在$l$的同一侧。假设$p, q$在$C$上，$r$在圆内，$s$在圆外，则

$$
    \angle arb > \angle apb = \angle aqb > \angle asb
$$

> 注： 这里书上194页给的叙述有误，该定理并不能保证a, r, b组成的最小的角符合上述要求，而是必须是以r为顶点的角，对于其他三个角也是如此。
