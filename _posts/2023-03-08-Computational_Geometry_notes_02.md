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
