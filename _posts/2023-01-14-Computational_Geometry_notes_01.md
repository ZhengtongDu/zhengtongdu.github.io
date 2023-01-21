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

(unfinished)

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

由于任意角度最优的三角剖分必然是合规的，因此定理9.8说明任意角度最优三角剖分也是Delaunay三角剖分。对于一般情况，由于只存在一个Delaunay三角剖分，故合规的三角剖分也只有一个，其自然就是唯一的角度最优三角剖分，于是我们借助Delaunay三角剖分将三角剖分的合规性和角度最优联系起来。

对于特殊情况，即存在$P$中超过3点共圆，且圆中不包含$P$中其它点，此时$P$的Delaunay三角剖分仍然都是合规的，但是并不都是角度最优的。但是我们仍然能够得到一个相对好的结论：这些三角剖分的角度序列中，最小的角度是相同的，即最小的角度与Delaunay图生成Delaunay三角剖分的方式无关。

上述结论可以总结为如下定理，通过泰勒斯定理即初等几何知识可以证明：

__Theorem 9.9__ 令$P$是平面上的点集。$P$的任意一个角度最优三角剖分都是Delaunay三角剖分。进一步地，任意$P$的Delaunay三角剖分的角度序列中，最小的角度大于等于$P$的任意一个三角剖分的角度序列中最小的角度。

### Computing the Delaunay Triangulation

通过第7章构造Voronoi图的形式，我们可以简单获得$\mathcal{DG}(P)$，之后通过对图中构造大于3的多边形进行合规的三角剖分便可以得到Delaunay三角剖分。本章将介绍一个不借助Voronoi图的方法：我们将通过 _随机增量法(Randomized incremental approach)_ 直接构造Delaunay三角剖分。我们已经在第四章和第六章中采取过一样的方法。

#### The Idea of Algorithm

1. 通过向$P$中添加额外两个点，与$P$中纵坐标最大的点构成可以包围其余点的三角形；
2. 以该三角形为基础剖分，每次向其中添加一个$P$中的点形成新剖分，并且通过维护保持剖分的合规性；
3. 在所有点添加完毕后，撤除额外的两个点及其它与之有连接的边。

#### Algorithm DelaunayTriangulation

```c++
Algorithm: DelaunayTriangulation(P)
/***
Input: A set P of n+1 points in the plane
Output: A Delaunay triangulation of P
***/

    //Initialization
    Shuffle P, and let P[0] be the lexicographically highest point of P 
    // That is, the rightmost among the points with largest y-coordinate
2   Let P[-1] and P[-2] be two point in the plane sufficiently far away 
    // Such that P is contained in the triangle tri(P[0], P[-1], P[-2])
    T <- tri(P[0], P[-1], P[-2])

    for r = 1 : n                       // Insert P[r] into P per loop

1       [i, j, k] = find(T, P, r)       // Find a triangle containing P[r]

        if P[r] is in tri(P[i], P[j], P[k])
            // Split tri(P[i], P[j], P[k]) into three triangles
            T <- tri(P[i], P[j], P[r])
            T <- tri(P[j], P[k], P[r])
            T <- tri(P[k], P[i], P[r])
            remove(T, tri(P[i], P[j], P[k]))

            // Legalization new edges
            LegalizeEdge(P[r], edge(P[i], P[j]), T);
            LegalizeEdge(P[r], edge(P[j], P[k]), T);
            LegalizeEdge(P[r], edge(P[k], P[i]), T);

        else    // P[r] lies on an edge of tri(T[i], T[j], T[k])

            // Assume that P[r] lies on edge(P[i], P[j]) and P[l] be
            // the third vertex of the other triangle containing edge(P[i], P[j])

            // Split tri(P[i], P[j], P[k]) into four triangles
            T <- tri(P[j], P[k], P[r])
            T <- tri(P[k], P[i], P[r])
            T <- tri(P[j], P[l], P[r])
            T <- tri(P[l], P[i], P[r])
            remove(T, tri(P[i], P[j], P[k]))
            remove(T, tri(P[i], P[j], P[l]))

            // Legalization new edges
            LegalizeEdge(P[r], edge(P[i], P[l]), T);
            LegalizeEdge(P[r], edge(P[i], P[k]), T);
            LegalizeEdge(P[r], edge(P[j], P[l]), T);
            LegalizeEdge(P[r], edge(P[j], P[k]), T);
                
    Discard P[-1] and P[-2] and associated edges from T 

    return T
```

```c++
LegalizeEdge(P[r], edge(P[i], P[j]), T)
// The point being inserted is P[r], and edge(P[i], P[j]) is the edge 
// of T that may need to be flipped
    if edge(P[i], P[j]) is illegal
        // Assume that tri(P[i], P[j], P[k]) be the other triangle
        // containing edge(P[i], P[j])
        Replace edge(P[i], P[j]) with edge(P[r], P[k])  // Edge flip
        LegalizeEdge(P[r], edge(P[i], P[k]), T)
        LegalizeEdge(P[r], edge(P[j], P[k]), T)
```

#### Algorithm Detail 1: Is The Algorithm Correct?

为了说明算法的正确性（可以通过其生成Delaunay三角剖分），首先介绍如下引理：

Lemma 9.10 对于插入$P[r]$的循环，算法DelaunayTriangulation()与LegalizeEdge()添加的新边都在点集$\{P[-2], P[-1], P[0],\dots, P[r]\}$生成的Delaunay图中。（证明见附录）

借助这个引理，我们可以很轻松地利用数学归纳法证明算法的正确性：插入$P[r]$后，如果一条边$e$是不合规的，那么说明$e$必然在一个以$P[r]$为顶点的三角形中（否则$e$在插入$P[r]$之前就是不合规的）。且每个通过DelaunayTriangulation()或LegalizeEdge()得到的新三角形，其中未经确认的边都会被执行LegalizeEdge()，这样就保证了所有不合规的边都会通过边翻转操作转为合规边，算法的正确性也就被证明了。

#### Algorithm Detail 2: How to find tri(P[i], P[j], P[k]) containing P[r]?

> 对应主算法伪代码中标记1的位置

这里我们用了类似第六章中的处理办法：设计一个额外的类似树的结构$\mathcal{D}$，其中每个节点为一个三角形，整体上$\mathcal{D}$一个有向无环图，并且保证$\mathcal{D}$的所有叶子节点对应当前状态下三角剖分的所有最小单位三角形，通过交叉链接实现$\mathcal{D}$与$\mathcal{T}$在基本单位上的一一映射。当向$\mathcal{T}$中添加新的点$P[r]$时，借助$\mathcal{D}$，我们就可以用一种类似于二分的方法进行搜索，快速确定$P[r]$所在的最小单位三角形。由于在算法执行过程中三角剖分始终在发生改变，下面我们详细介绍一下应当如何维护$\mathcal{D}$：

添加新节点时：在插入$P[r]$时，我们会遇到两种情况：

- 第一种情况是点$P[r]$落在三角形$tri(P[i], P[j], P[k])$中，这种情况下我们需要将$tri(P[i], P[j], P[k])$分为三个新的三角形；
- 第二种情况，是点$P[r]$落在三角形$tri(P[i], P[j], P[k])$的边上，则此时我们需要将$tri(P[i], P[j], P[k])$分为两个新的三角形。
 
对于这两种情况，我们都只需要在原本$\mathcal{D}$对应到$tri(P[i], P[j], P[k])$的叶子结点下新添加2或3个子节点，对应新添加的三角形即可。

除了原有的三角形分裂，对于边翻转操作，因为其本质上是重新对一个凸四边形重新作划分，所以当进行边翻转操作时，我们只需要将原有的两个组成凸四边形的叶子节点，指向由两个新的三角形生成的节点，从而实现维护$\mathcal{D}$的目的。

#### Algorithm Detail 3: How to choose P[-1] and P[-2] appropriately?

> 对应主算法伪代码中标记2的位置

由于我们在算法中对于$P[-1]$和$P[-2]$有如下两点限制：

- $P[-1]$和$P[-2]$应当与$P$保持充分远的距离，从而保证引入它们并不破坏计算Delaunay三角剖分；
- $P[-1]$和$P[-2]$不能距离$P$过于远，否则不仅加大计算难度，还可能会引入不必要的误差。

整体审视算法流程，我们发现涉及到$P[-1]$和$P[-2]$的计算过程有两个，第一个是判断新插入的点是否处在三角形中，第二个是判断边是否合规。由于上述两个限制，对于不同的点集$P$定义不同的$P[-1]$和$P[-2]$比较困难。我们将通过对$P[-1]$和$P[-2]$的定义上添加额外条件，使得整个流程中不需要给出$P[-1]$和$P[-2]$的具体值，当上面两个计算过程涉及到$P[-1]$和$P[-2]$时采取其他等价条件代替，从而在满足限制的同时完成需要的计算过程。

在添加额外的条件之前，需要定义平面上如下字典序关系：平面上定义两点$p = (x_p, y_p), q = (x_q, y_q), p \ne q$，我们定义$p>q$当且仅当$y_p > y_q$或者$y_p = y_q, x_p > x_q$。

有了字典序之后，我们可以借助$P$来定义$P[-1], P[-2]$（注意：虽然$P$上现在有了字典序，但是算法流程中是 __不需要进行预先排序的__）

1. 令$l_{-1}$是低于$P$的一条水平直线，$P[-1]$位于$l_{-1}$上，满足（当$P[-1]$的$x$轴坐标足够大，$y$轴坐标足够小时能实现）
   1. $P[-1]$在$P$上任意非共线三点定义的圆外；
   2. $P[-1]$从$x$轴正方向开始，顺时针扫描$P$集，其扫过点的顺序同$P$集按字典序升序得到的顺序相同。
2. 令$l_{-2}$是高于$P$的一条水平直线，$P[-2]$位于$l_{-2}$上，满足（当$P[-2]$的$x$轴坐标足够小，$y$轴坐标足够大时能实现）
   1. $P[-2]$在$P\cup \{P[-1]\}$上任意非共线三点定义的圆外；
   2. $P[-2]$从$x$轴正方向开始，逆时针扫描$P$集，其扫过点的顺序同$P$集按字典序升序得到的顺序相同。

通过这样的 _形式化定义_$P[-1]$和$P[-2]$，我们可以得到$P$的Delaunay三角剖分与$P\cup \{P[-1], P[-2]\}$的Delaunay三角剖分的关系：

- 

于是我们可以解决前面提到的两个计算过程中遇到$P[-1]$和$P[-2]$的情况：



### The Analysis

(unfinished)

### Appendix: The Proof of Theorems

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

证明：通过定理9.2及定理9.7，易得Delaunay三角剖分是合规的。下面利用反证法说明任意合规的三角剖分是Delaunay三角剖分。

(unfinished)

#### Lemma 9.10

Lemma 9.10 LegalizeEdge()添加的新边都在点集$\{P[-2], P[-1], P[0],\dots, P[r]\}$生成的Delaunay图中。

证明：

