---
layout: post
title: Computational_Geometry_notes_02
date: 2023-03-08 15:23 +0800
tags: ["learning", "Computational Geometry"]
toc: true
---

Lecture 07 Voronoi Diagrams

> To solve the Post Office Problem

### Introduction

(unfinished)

### Definition and Basic Properties

令 $P := \{p_1, p_2, \dots, p_n\}$ 为平面上的一组点集，我们定义平面上 $P$ 的Voronoi图将平面划分为 $n$ 个元胞(cell)，每个点占据一个元胞，并且满足对于 $p_i$ 的元胞中任意一点 $q$ ，有对于任意的 $j \ne i$ 都有 $\mathrm{dist}(q,p_i) < \mathrm{dist}(q, p_j)$ 。我们将 $P$ 的Voronoi图记作 $\mathrm{Vor}(P)$ ，包含 $p_i$ 的元胞记作 $\mathcal{V}(p_i)$ 。

首先考虑一个Voronoi图中元胞的结构。对于相邻的元胞，其中 $P$ 的两个点 $p, q$ 是被它们连线的 __中垂线__ 划分的。如果我们将其中划分之后的平面中包含 $p$ 的半平面记作 $h(p, q)$ ，另半个平面记作 $h(q, p)$ ，那么点 $r\in h(p, q)$ 等价于 $\mathrm{dist}(r,p) < \mathrm{dist}(r, q)$ 。进一步地，

$$\mathcal{V}(p_i) = \cap_{1\le j \le n, j\ne i}h(p_i, p_j).$$

通过上面的观察还可以知道，每个元胞都是（可能无界的）至多由 $n - 1$ 条边围成的凸多边形区域。

对于最终的Voronoi图的形状，由如下结论

__Theorem 7.2__ 令 $P$ 是平面上 $n$ 个点的集合。如果所有的点都是共线的，那么 $\mathrm{Vor}(P)$ 由 $n - 1$ 条平行直线组成；否则 $\mathrm{Vor}(P)$ 由线段或射线组成。

接下来说明 $\mathrm{Vor}(P)$ 的复杂度（组成其所需的线段/射线/直线数量）是线性的：

__Theorem 7.3__ 当 $n \ge 3$ 的时候，平面上 $n$ 点集合 $P$ 的Voronoi图最多有 $2n - 5$ 个顶点，最多有 $3n - 6$ 条边。

本节最后给出一个Voronoi图的顶点和边满足的性质，因为并不是任意两点连线的中垂线都定义了 $\mathrm{Vor}(P)$ 中的一条边。为此我们首先定义平面上点 $q$ 关于点集 $P$ 的 __最大空圆__ 为以 $q$ 为圆心且内部不包含任何 $P$ 中点的最大圆，记为 $C_P(q)$ 。

__Theorem 7.4__ 对于点集 $P$ 的Voronoi图 $\mathrm{Vor}(P)$ ，如下结论成立：

- 点 $q$ 是 $\mathrm{Vor}(P)$ 的顶点当且仅当它的最大空圆 $C_P(q)$ 的边界上含有3个或更多 $P$ 中点；
- $p_i$ 和 $p_j$ 连线的中垂线定义了 $\mathrm{Vor}(P)$ 中的一条边当且仅当其上存在一点 $q$ ，它的最大空圆 $C_P(q)$ 的边界上包含 $p_i$ 和 $p_j$ 但不包含其他 $P$ 上的点。

### Computing the Voronoi Diagram

接下来我们将用时间复杂度为 $O(n\log n)$ 的Fortune's Algorithm来计算 $P$ 的Voronoi图。值得说明的是，计算Voronoi图任一算法的时间复杂度都是 $\Omega(n\log n)$ 的。

我们将仿照扫描线算法，计算 $P = \{p_1, p_2, \dots, p_n\}$ 的Voronoi图。我们将从顶到底移动一根水平的扫描线 $l$ 。根据范式，我们需要在移动扫描线的过程中维护其与Voronoi图的交点，但是Voronoi图位于 $l$ 上方的部分不仅由 $P$ 中的位于 $l$ 上方的点决定，因此我们并无法即时获取计算 $\mathrm{Vor}(P)$ 位于 $l$ 上方的全部信息。因此这里需要对扫描线算法进行修改：代替维护扫描线与 $\mathrm{Vor}(P)$ 的交点信息，我们维护由 $P$ 中位于扫描线 $l$ 上的点组成的Voronoi图中不会被添加位于 $l$ 之下顶点改变部分的信息。

记 $l$ 上方的半平面为 $l^+$ ，如果 $l^+$ 中的一个点到 $l$ 的距离小于等于到 $P$ 在 $l$ 上方部分的一点距离，那么这个点所处的元胞就已经被确定了。根据初等数学的知识，到 $p_i\in l^+$ 中的距离小于到 $l$ 距离的点被一条抛物线所包围，到 $l^+$ 之上任意一个 $p_i$ 的距离小于到 $l$ 距离的点就被多条抛物线相交后连接得到的弧所包围，我们称这个由抛物线序列组成的弧为 __海滩线__ 。显然，海滩线是关于 $x$ 的函数，每条竖直线与其有且只有一个交点。

接下来我们通过研究海滩线来确定如何改进扫描线算法。事实上，由于每条抛物线记录的都是到其焦点（即 $P$ 中一点）与准线（即 $l$ ）相等的点，因此两条抛物线的交点就是到 $P$ 中两个点距离都等于 $l$ 距离的点，这样的点最后其实也是 $\mathrm{Vor}(P)$ 中的点。因此，代替考察 $\mathrm{Vor}(P)$ 与 $l$ 的交点，我们将维护不同时刻海滩线的中断点信息（即两条抛物线的交点）。接下来我们通过分析随着扫描线 $l$ 不断下移，海滩线中每段弧产生和消失的过程，来定义两种不同的事件。

首先我们考虑使海滩线中产生一段新的弧的事件，它是由于 $l$ 新扫描到 $P$ 中的一个点 $p_i$ 而产生。此时海滩线会在 $p_i$ 的位置分裂处两条极陡的抛物线，之后随着 $l$ 的下移，它们渐渐向左右两侧拓展，变成新的弧，我们称 $l$ 遭遇 $P$ 中一点为 __点事件__ 。对于点事件有如下性质：

__Lemma 7.6__ 海滩线中出现一段新的抛物线弧的唯一途径就是 $l$ 遇到一个点事件。

该引理还可以说明海滩线最多包含 $2n - 1$ 段抛物线弧。

接下来我们考虑海滩线中一段弧逐渐收缩到一点并消失的事件。记 $\alpha'$ 为将要消失的弧， $\alpha, \alpha''$ 为与其相邻的两段弧，由于 $\alpha, \alpha''$ 不可能属于同一条抛物线，这样记 $\alpha, \alpha', \alpha''$ 分别对应 $p_i, p_j, p_k$ 。 $\alpha'$ 消失的时刻对应了由三个点定义的抛物线汇聚到了同一个点，记其为 $q$ 。此时 $q$ 到 $l$ 的距离等于其到 $p_i, p_j, p_k$ 的距离。因此存在圆心为 $q$ 的圆，其边界过 $p_i, p_j, p_k$ 且与 $l$ 相切，且其内部不可能包含 $P$ 中的其他点（否则 $\alpha, \alpha', \alpha''$ 不可能相邻），于是我们根据前面的定理可以直到 $q$ 是 $\mathrm{Vor}(P)$ 中的顶点。我们将这种扫描线 $l$ 移动到三个相邻弧对应点所在的圆的最低端的事件称为 __圆事件__ ，它满足如下性质：

__Lemma 7.7__ 海滩线上一段已有的抛物线弧消失的唯一途径是 $l$ 遇到一个圆事件。

现在我们对海滩线的结构进行总结：扫描线经过一个点事件时海滩线中会产生新的弧；扫描线经过一个圆事件的时候海滩线中的一段弧会消失。对应到Voronoi图的生成过程：扫描线经过一个点事件，图中就有一条新的边开始绘制；扫描线经过一个圆事件，图中两条延伸的边就会相遇并且生成Voronoi图的一个顶点。接下来我们将根据上面的信息定义算法中具体的数据结构，它们应该包括以下几种：

- 随着 $l$ 不断下移，记录当前的Voronoi图的结构
- 扫描线算法（范式）都需要的两种数据结构：
  - 存储待处理事件的队列结构
  - 表示当前扫描线状态（海滩线）的结构

接下来详细说明这三种结构：

- 我们利用双向链接的边列表来存储正在构建的Voronoi图，这是解决细分问题的常规结构。然而由于Voronoi图中的边并不全是线段，也有射线或者直线。虽然这不会影响构建Voronoi图的过程，但是在构建完成后，我们希望得到一个有效的双向链接的边列表。为此我们需要在场景中添加一个足够大的包围盒，以涵盖所有Voronoi图中的顶点，最后我们计算的结果将是包围盒及其中的Voronoi图的部分。
- 我们用平衡二叉树 $\mathcal{T}$ 来维护海滩线的信息，这是一个记录状态的结构。树的每个叶子节点对应海滩线上的每段抛物线弧，弧的顺序和叶子结点的顺序相对应：最左侧的叶子结点对应最左侧的弧，从左数第二个叶子结点对应左侧第二个弧。每个节点中存储的是定义这段弧所对应的抛物线的 $P$ 中的点。 $\mathcal{T}$ 中内部的节点表示海滩线中的中断点，尺寸出的方式使用一个有序元组 $\langle p_i, p_j\rangle$ ，其中 $p_i$ 是中断点左侧的抛物线弧所对应的 $P$ 中的点， $p_j$ 是中断点右侧的抛物线弧所对应的 $P$ 中的点。利用二叉树来表示海滩线，我们可以用 $O(\log n)$ 的时间里确定新添加 $P$ 中的点的时候其弧应当添加的位置。注意到我们并没有直接存储抛物线。在 $\mathcal{T}$ 中，我们还存储了扫描过程中用到的另外两个数据结构的指针。 $\mathcal{T}$ 中的每个叶子节点对应了一段海滩线中的弧 $\alpha$ ，存储了其在事件队列中的一个节点的指针，即对应了队列中这段弧消失的圆事件的节点。如果这个指针是空指针，则说明这段弧对应的圆事件不存在，或者它的圆事件还没有被检测到； $\mathcal{T}$ 中内部的每个节点 $v$ 对应Voronoi图的双向链接的边列表中一条边的一半，具体地说， $v$ 中包含的指针对应这个节点对应的中断点所在的那条边的一半。
- 我们用优先队列来表示事件队列 $\mathcal{Q}$ ，其优先级用每个事件点的 $y$ 坐标来表示。它存储了已知的待发生的事件。对于点事件，我们用 $P$ 中对应点的坐标来记录；对于圆事件，我们用这个圆的最低点来记录，还要用一个指针记录在树 $\mathcal{T}$ 中将要消失的那段弧的节点。

所有的点事件都是事先知道的，但是圆事件不是。所以这节的最后还需要讨论如何检测圆事件。

在扫描线经过每个事件点的时候，它的弧组成都会发生变化，因此在扫描过程中会有新的相邻的弧组成的三元组产生，这些三元组中有的可能会对应一个令中断点消失的圆事件。算法可以确保对海滩线上每个相邻的三段弧组成的元组，都会在事件队列中存储一个可能的圆事件点，其中有两种情况需要特别考虑。第一种是三段弧产生的两个中断点根本不会收敛到一起，这时候两个中断点实际上是沿着从一个Voronoi图中顶点引出的两条边以相背的方向延伸，对于这种情况，算法可以提前对其处理，从而不会生成这样的圆事件点；第二种情况是虽然中断点会收敛，但是相应的圆事件却因为这个相邻弧的三元组先消失而不会发生（比如在圆事件发生之前三条弧新检测到了点事件），对于这种情况我们称这个事件为 __误报事件__ 。

所以我们需要处理误报事件。在处理每个事件的时候，算法需要检测所有新出现的连续三段弧组成的元组，如果这些元组中存在使中断点收敛的可能，那么就向事件队列 $\mathcal{Q}$ 中插入一个潜在的圆事件。同样，对于处理每个事件时破坏连续三段弧组成的元组，我们也需要检测 $\mathcal{Q}$ 中是否有这个元组定义的圆事件点，如果存在则它显然是一个误报事件，我们需要将其从 $\mathcal{Q}$ 中删除这个误报事件。这样的处理方式因为事先已经在 $\mathcal{T}$ 中每个叶子结点中添加了 $\mathcal{Q}$ 中对应事件点的指针而变得非常简单。

__Lemma 7.8__ Voronoi图中的每个顶点都可以通过一个圆事件检测到。

接下来我们就可以详细地介绍平面扫描算法了。注意到当所有事件都被处理过后，此时事件队列 $\mathcal{Q}$ 为空，但是海滩线还没有消失。由于Voronoi图中一些边是射线，海滩线中还会存在一些中断点。正如在前面提到的，一个双向链接的边列表不能表示射线，所以我们必须向场景中再添加一个可以控制每条边的包围盒。算法总览如下：

```c++
Algorithm VoronoiDiagram(P)
/***
Input:  A set P := {p_1, p_2, ..., p_n} of point sites in the plane
Output: The Voronoi diagram Vor(P) given inside a bounding box in a 
        doubly-connected edge list D
***/
Initialize the event Q with all site events, initialize an empty status 
   structure T and an empty doubly-connected edge list D
while Q is not empty
    Remove the event with largest y-coordinate from Q,
    if the event is a site event, occurring at site p_i
      HandleSiteEvent(p_i)
    else
      HandleCircleEvent(gamma), where gamma is the leaf of T represent-
        ing the arc that will disappear
The internal nodes still present in T correspond to the half-infinite edges 
  of the Voronoi diagram. Compute a bounding box that contains all vertices 
  of the Voronoi diagram in its interior, and attach the half-infinite edges 
  to the bounding box by updating the doubly-connected edge list appropriately.
Traverse the half-edges of the doubly-connected edge list to add the cell
  records and the pointers to and from them
```

其中处理两种不同的事件算法如下：

```c++
HandleSiteEvent(p_i)
If T is empty, insert p_i into it and return. Otherwise continue.
Search in T for the arc alpha vertically above p_i. If the leaf representing
  alpha has a pointer to a circle event in Q, then this circle event is a 
  false alarm and it must be deleted from Q.
Replace the leaf of T that represents alpha with a subtree having three
  leaves. The middle leaf stores the new site p_i and the other two leaves
  store the site p_j that was originally stored with alpha. Store the tuples 
  <p_j, p_i> and <p_i, p_j> representing the new breakpoints at the two new 
  internal nodes. Perform rebalancing operations on T if necessary.
Create new half-edge records in the Voronoi diagram structure for the
  edge separating V(p_i) and V(p_j), which will be traced out by the two new 
  breakpoints.
Check the triple of consecutive arcs where the new arc for p_i is the left arc
  to see if the breakpoints converge. If so, insert the circle event into Q 
  and add pointers between the node in T and the node in Q. Do the same for
  the triple where the new arc is the right arc.
```

```c++
HandleCircleEvent(gamma)
Delete the leaf gamma that represents the disappearing arc alpha from T. 
  Update the tuples representing the breakpoints at the internal nodes.
  Perform rebalancing operations on T if necessary. Delete all circle events 
  involving alpha from Q; these can be found using the pointers from the predecessor and the successor of gamma in T.
Add the center of the circle causing the event as a vertex record to the
  doubly-connected edge list D storing the Voronoi diagram under construction. 
  Create two half-edge records corresponding to the new breakpoint of the
  beach line. Set the pointers between them appropriately. Attach the three 
  new records to the half-edge records that end at the vertex.
Check the new triple of consecutive arcs that has the former left neighbor 
  of alpha as its middle arc to see if the two breakpoints of the triple 
  converge. If so, insert the corresponding circle event into Q, and set 
  pointers between the new circle in Q and corresponding leaf of T. Do the 
  same for the triple where the former right neighbor is the middle arc.
```

__Lemma 7.9__ 上述算法的时间复杂度为 $O(n\log n)$ ，空间复杂度为 $O(n)$ 。

在结束本节之前，我们还要再介绍一下上述算法中遇到的退化情况。

该算法中的退化情况有以下几种，其一是多个事件点出现在一条水平线但是 $x$ 坐标不同，其二是多个事件点重合。对于第一种情况，我们只需要补充对“算法开始时遇到多个点事件”这种退化情况的处理，其他情况按任意顺序处理事件点即可；对于第二种情况，比如四点共圆，这时候我们并不需要特殊处理，只需要把它看作两个三点共圆事件，得到的两个 $\mathcal{Vor}(P)$ 中的顶点被一条长度为0的边连接即可。此外，还有一些退化情况，比如新的事件点刚好在两条抛物线弧的交点下出现等等，这些情况也和情况二一样，都可以视作产生或消除了长度为0的抛物线弧或者边，因此并不会影响到算法的运行。我们可以在最后得到边列表之后对这些顶点重合的情况进行一步后处理。

__Theorem 7.10__ 对平面上 $n$ 个点组成的点集，利用扫描线算法计算其Voronoi图的时间复杂度为 $O(n\log n)$，空间复杂度为 $O(n)$ 。

### Advanced Topics

### Appendix: The Proof of Theorems

#### Theorem 7.2

Theorem 7.2 令 $P$ 是平面上 $n$ 个点的集合。如果所有的点都是共线的，那么 $\mathrm{Vor}(P)$ 由 $n - 1$ 条平行线组成；否则 $\mathrm{Vor}(P)$ 由线段或射线组成。

证明：

#### Theorem 7.3

Theorem 7.3 当 $n \ge 3$ 的时候，平面上 $n$ 点集合 $P$ 的Voronoi图最多有 $2n - 5$ 个顶点，最多有 $3n - 6$ 条边。

证明：

#### Theorem 7.4

Theorem 7.4 对于点集 $P$ 的Voronoi图 $\mathrm{Vor}(P)$ ，如下结论成立：

- 点 $q$ 是 $\mathrm{Vor}(P)$ 的顶点当且仅当它的最大空圆 $C_P(q)$ 的边界上含有3个或更多 $P$ 中点；
- $p_i$ 和 $p_j$ 连线的中垂线定义了 $\mathrm{Vor}(P)$ 中的一条边当且仅当其上存在一点 $q$ ，它的最大空圆 $C_P(q)$ 的边界上包含 $p_i$ 和 $p_j$ 但不包含其他 $P$ 上的点。

证明：

#### Lemma 7.6

Lemma 7.6 海滩线中出现一段新的抛物线弧的唯一途径就是 $l$ 遇到一个点事件。

证明：

#### Lemma 7.8

Lemma 7.8 Voronoi图中的每个顶点都可以通过一个圆事件检测到。

证明：

#### Lemma 7.9

Lemma 7.9 上述算法的时间复杂度为 $O(n\log n)$，空间复杂度为 $O(n)$ 。

证明：
