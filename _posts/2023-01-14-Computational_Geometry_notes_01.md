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

在介绍Delaunay三角剖分之前，我们先介绍Voronoi图的对偶图——Delaunay图。

#### Delaunay Graph

回顾第七章的内容，对于平面上包含$n$个点的点集$P$，可以生成它的Voronoi图：将平面分为$n$个区域，每个区域包含$P$中的一个点。Voronoi图可以保证在该其划分下，平面上任意一点到$P$中最近的一点即为该区域包含的那个点，对于包含$p\in P$的区域，我们称之为 _Voronoi元胞(Voronoi cell)_，记作$\mathcal{V}(p)$。

如果对于$P$的Voronoi图，我们考虑构造满足如下条件的图$\mathcal{G}$：

- $\mathcal{G}$的每个顶点对应一个Voronoi元胞；
- 如果两个相邻的Voronoi元胞共享Voronoi图中的一条边，那么$\mathcal{G}$就有一条连接对应这两个元胞顶点的边。

如果这样定义的$\mathcal{G}$中，每条边都是直线段，我们就称其为嵌入$P$中的 _Delaunay 图_，记为$\mathcal{DG}(P)$。

#### Delaunay Triangulation

借助Delaunay图，我们可以得到$P$的合规的，并且在一定条件下也是角度最优的三角剖分。Delaunay图具有如下几条性质。

- 平面点集的Delaunay图是平面图（证明见附录）
- 如果Voronoi图中，$k$条边相交于同一顶点（或者说这个顶点的度数是$k$），那么对应元胞中包含的$P$中的点$p_1, p_2, \dots, p_k$，共圆，进而在Delaunay图中构成一个$k$边形（证明在第七章）

由此我们可以将Delaunay分为两种情况，第一种情况为一般情况，此时所有Voronoi图中顶点的度数都是3，则此时Delaunay图$\mathcal{DG}(P)$即为$P$的一个三角剖分；第二种情况下，存在Voronoi图中度数大于3的顶点，则此时我们需要通过继续添加边，来将Delaunay图转化为三角剖分。

由此，对于通过对Delaunay图添加边得到的三角剖分，我们将其称为 _Delaunay 三角剖分(Delaunay Triangulation)_。

由于Delaunay图中的多边形都是凸的，因此通过添加边获得Delaunay三角剖分简单；此外，对于一般情况，由于$\mathcal{DG}(P)$是三角剖分，此时的Delaunay三角剖分也是唯一的。

我们重新从Delaunay图的角度来叙述第七章中定理7.4的内容：

__Theorem 9.6__ 令$P$是平面上的点集。

- $P$上的三个点$p_i, p_j, p_k$为$\mathcal{DG}(P)$中同一个多边形的顶点当且仅当$p_i, p_j, p_k$三点同在的圆中不包含$P$上的其它点；
- $\overline{p_ip_j}$是$\mathcal{DG}(P)$的边当且仅当存在一个圆盘$C_{ij}$，$p_i, p_j$在其边界上，且其它$P$上的点不在圆盘上。

定理9.6隐含了Delaunay三角剖分的如下性质：

__Theorem 9.7__ 令$P$是平面上的点集，$\mathcal{T}$是$P$的一个三角剖分。则$\mathcal{T}$是$P$的Delaunay三角剖分当且仅当它的任一三角形的外接圆内不包含$P$中的其它点。

#### The Legality of Delaunay Triangulation

接下来我们讨论Delaunay三角剖分在合规性方面的优越。

__Theorem 9.8__ 令$P$是平面上的点集。$P$的一个三角剖分$\mathcal{T}$是Delaunay三角剖分当且仅当它是合规的。（证明见附录）

### Computing the Delaunay Triangulation

### The Analysis

### Appendix: The proof of theorems

#### Theorem 9.2 泰勒斯定理(Thales's Theorem):

Theorem 9.2 (Thales's Theorem): 令$C$为一个圆，$l$为与$C$相交的一条直线，两个交点分别为$a, b$。$p, q, r, s$在$l$的同一侧。假设$p, q$在$C$上，$r$在圆内，$s$在圆外，则

$$
    \angle arb > \angle apb = \angle aqb > \angle asb
$$

> 注： 这里书上194页给的叙述有误，该定理并不能保证a, r, b组成的最小的角符合上述要求，而是必须是以r为顶点的角，对于其他三个角也是如此。

#### Theorem 9.5

Theorem 9.5 平面点集的Delaunay图是平面图

证明：要证明这一点，需要借助第七章定理7.4的内容。用Delaunay图的形式重新叙述如下：

> $\overline{p_ip_j}$是Delaunay图$\mathcal{DG}(P)$的边，当且仅当存在一个圆盘$C_{ij}$，使得$p_i, p_j$在其边缘上，并且其他$P$上的点不在圆盘上（此时$C_{ij}$的圆心在$\mathcal{V}(p_i)$和$\mathcal{V}(p_j)$的共同边上）。

定义$t_{ij}$为顶点为$p_i, p_j$以及$C_{ij}$的圆心的三角形，注意到$t_{ij}$中连接$p_i$和$C_{ij}$的圆心的边在$\mathcal{V}(p_i)$中，对于$p_j$也有相同的结果。根据之前的假设，这两个边不会同其他$\mathcal{DG}(P)$中的边相交，因此我们只需要考虑$\overline{p_ip_j}$。

假设现在存在$\mathcal{DG}(P)$中的另外一条边$\overline{p_kp_l}$，其与$\overline{p_ip_j}$相交。同之前一样，我们也定义相同的圆$C_{kl}$和三角形$t_{kl}$。根据假设，$p_k, p_l$在圆$C_{ij}$外，必然也在$t_{ij}$外。故$\overline{p_kp_l}$必然还会与$C_{ij}$的圆心和$p_i$或$p_j$的连线之一相交；同样地，$\overline{p_ip_j}$也还会与$C_{kl}$的圆心和$p_k$或$p_l$的连线之一相交。由此可以推出$C_{ij}$的圆心和$p_i$或$p_j$的连线之一会和$C_{kl}$的圆心和$p_k$或$p_l$的连线之一相交，但这些边分别包含在不同的Voronoi元胞中矛盾。

#### Theorem 9.8

Theorem 9.8 令$P$是平面上的点集。$P$的一个三角剖分$\mathcal{T}$是Delaunay三角剖分当且仅当它是合规的。

证明：
