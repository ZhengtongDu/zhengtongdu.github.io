---
layout: post
title: Design_Documentation01
date: 2023-02-28 13:46 +0800
tags: ["Learning Notes", "Design Document"]
toc: true
---
[delaunaytriangulation]:https://zhengtongdu.github.io/2023/01/14/Computational_Geometry_notes_01/

> 整理了自己写的一些算法实现的设计思路

## Delaunay Triangulation

> 理论及算法的介绍：请参见[这里][delaunaytriangulation]，《Computational Geometry》书中第九章的笔记

程序最后实现了如下目标：对于输入的散点（通过触发鼠标事件或者在main.cpp中设定）：
![fig01: scattered points](/assets/23-02-28-fig01.png){:height="300px" width="300px"}

生成其对应的Delaunay三角剖分网格：
![fig02: delaunay triangulation of above points](/assets/23-02-28-fig02.png){:height="300px" width="300px"}

### 设计1：底层类的设计

底层类中定义了Vector类、Triangle类：

```c++
class Vector2f
{
public:
    // Constructors
    Vector2f();
    Vector2f(const float&);
    Vector2f(const float&, const float&);
    
    // Operators overloading
    Vector2f operator*(const float&) const;
    Vector2f operator/(const float&) const;
    Vector2f operator+(const Vector2f&) const;
    Vector2f operator-(const Vector2f&) const;
    Vector2f operator-() const;
    Vector2f operator+=(const Vector2f&);
    bool operator==(const Vector2f&);
    bool operator!=(const Vector2f&);
    friend Vector2f operator*(const float&, const Vector2f&);
    friend std::ostream& operator<<(std::ostream&, const Vector2f&);
    // Get the norm of a vector
    float norm() const;
    // Return the normalized vector(but not change original vector)
    Vector2f normalize() const;
    // Return the normalized vector(and change original vector)
    Vector2f normalized();
    // Compute the dot product
    float dotProduct(const Vector2f&) const;
    // Return value is positive when the vector obtained 
    // by cross product points to the outer of plane.
    float crossProduct(const Vector2f&) const;
    // Data members
    float x, y;
};
```

```c++
class Triangle
{
public:
    // Constructor
    Triangle(const Vector2f&, const Vector2f&, const Vector2f&);
    // Ostream operator overloading
    friend std::ostream& operator<<(std::ostream&, const Triangle&);
    // Data members
    Vector2f v0, v1, v2; // vertices A, B, C, counter-clockwise order
};
```

对于输入的点集，这里利用的是stl库中的vector容器中包含自己定义的Vector2f，这样的好处在于可以使自己在处理一些简单事情的时候（比如统计点集规模、添加点）可以不用额外定义函数了。

### 代码结构02 用来实现Delaunay三角剖分的链表结构

正如[理论][delaunaytriangulation]中所说，为了能够实现按点添加的算法，我们除了直接存储网格中现有的三角形结构，还需要存储之前删除的三角形结构，并能体现一定的包含关系，因此我定义了两类新的数据结构：树和链表：

树节点及树：

```c++
struct TreeNode{
    int tri_v0, tri_v1, tri_v2;
    std::shared_ptr<TreeNode> child0, child1, child2;
    int childNum;
    std::shared_ptr<ListNode> listnode;
    TreeNode(int _v0, int _v1, int _v2)
};
class TriangleTree
{
public:
    TriangleTree();
    ~TriangleTree();
public:
    std::shared_ptr<TreeNode> root;
};
```

链表节点及链表：

```c++
struct ListNode{
    int tri_v0, tri_v1, tri_v2;
    std::shared_ptr<ListNode> pre, next;
    std::shared_ptr<TreeNode> treenode;
    ListNode(int _v0, int _v1, int _v2)
};

class TriangleList
{
public:
    // Basic operations
    void addPoint(const std::vector<Vector2f>&, const int&, TriangleTree&, TriangleList&);
    void triangulation(std::vector<Vector2f>&);
    // Legalize edges
    void linkEdge(std::shared_ptr<ListNode>);
    void unlinkEdge(const int, const int, std::shared_ptr<ListNode>);
    void unlinkEdge(std::shared_ptr<ListNode>);
    void legalizeEdge(const int, const int, const int, const std::vector<Vector2f>&);
    // Rendering
    void drawTriangulation(const std::vector<Vector2f>&, Screen&);
    // Data members
    std::shared_ptr<ListNode> head;
    std::vector<std::vector<std::vector<std::shared_ptr<ListNode>>>> edgeTable;
};
```

这里有两个设计是值得特别注意的：

- 节点结构（ListNode和TreeNode）并没有定义在对应的类（TriangleList和TriangleTree）内，这样做的原因是我们需要两种节点交叉引用，但是如果定义在类内的话，但我们进行交叉引用的时候，编译器就会因为没有提前声明两个节点结构而报错。
- 所有用到的指针都是智能指针（smart pointer）而并非原始指针（raw pointer），因此并没有写相应的析构函数（都使用了标准库中容器的默认析构函数），这样做的原因是当我们处理边翻转的情况的时候，需要将两个三角形的子节点对应到另外两个子节点，这样的设计在进行递归析构的时候就会产生问题：由于析构函数中采用了后序遍历的方法析构每个树节点，这样两个子节点的位置就会被析构两次，从而造成内存泄漏。

### 代码结构03 核心算法的实现

这个部分都在DelaunayTriangulation.h文件中。按理论中的内容，按顺序说明如下：

#### 如何处理Bounding Triangle?

这里是按书中算法，设定了两个“观念上的”额外点，用来在定义的时候它们的坐标设定为-1和-2，并且在进入添加点的循环之前，首先创造了一个bounding triangle：

```c++
    // construct bounding triangle
    head.reset(new ListNode(-2, -1, 0));
    TriangleTree tree;
    tree.root.reset(new TreeNode(-2, -1, 0));
    linkEdge(head);
    crossLink(head, tree.root);
```

在其他几个函数中，因为可能涉及到处理bounding triangle，因此额外添加了对应的解决办法：

- bool isLeft()：用来判断一个点是否在一个三角形中；
- bool isLegal()：用来判断一条边是否合规（若不合规需要进行边翻转操作）

此外，在定义存储链表节点的邻接矩阵中，也要相应的把规模扩大2。

在结束的时候，记得要把所有带有辅助点的三角形从链表结构中撤除：

```c++
    // remove unreal triangles
    std::shared_ptr<ListNode> ptr = head;
    while(ptr != nullptr) {
        if(ptr->tri_v0 < 0 || ptr->tri_v1 < 0 || ptr->tri_v2 < 0) {
            if(ptr == head) {
                head = head->next;
                head->pre = nullptr;
                ptr.reset();
                ptr = head;
            }
            else {
                std::shared_ptr<ListNode> tmp = ptr->next;
                ptr->pre->next = ptr->next;
                if(ptr->next != nullptr)
                    ptr->next->pre = ptr->pre;
                ptr.reset();
                ptr = tmp;
            }
        }
        else
            ptr = ptr->next;
    }
```

#### 如何添加新的点到已有三角形节点链表中？

首先，我们需要判断一个点是否在一个三角形中，采取的方法是通过外积的符号去判断该点与三条边的（在平面上的）位置关系（点在边所处直线划分出的左半平面还是右半平面）：

```c++
    bool inTriangle(const int indr, const int ind0, const int ind1, const int ind2, const std::vector<Vector2f>& pointSet) {
    if(isLeft(indr, ind0, ind1, pointSet) == false || isLeft(indr, ind1, ind2, pointSet) == false || isLeft(indr, ind2, ind0, pointSet) == false)
        return false;
    return true;
    }
```

整体上，我们利用了树结构来处理不同层次的点相互之间的嵌套关系：

```c++
    void findTriangle(const int indr, const std::shared_ptr<TreeNode> ptr, std::vector<std::shared_ptr<ListNode>>& ptrVec, const std::vector<Vector2f>& pointSet) {
        if(ptr == nullptr)  return;
        if(inTriangle(indr, ptr->tri_v0, ptr->tri_v1, ptr->tri_v2, pointSet)) {
            if(ptr->child0 == nullptr) {
                for(int i = 0; i < ptrVec.size(); i++)
                    if(ptrVec[i] == ptr->listnode)    return;
                ptrVec.push_back(ptr->listnode);
                return;
            }
            else {
                findTriangle(indr, ptr->child0, ptrVec, pointSet);
                findTriangle(indr, ptr->child1, ptrVec, pointSet);
                findTriangle(indr, ptr->child2, ptrVec, pointSet);
            }
        }
        return ;
    }
```

为了实现这样的目的，我们还需要在新建每个树节点和链表节点之后，进行一步 __交叉引用__ 的操作：

```c++
    void crossLink(std::shared_ptr<ListNode> lnode, std::shared_ptr<TreeNode> tnode) {
        lnode->treenode = tnode;
        tnode->listnode = lnode;
    }
```

在有了上述的基础之后，我们就可以进行添加点的操作，注意到有两种可能的添加点方式：点位于三角形中，就把这个三角形分裂成三个三角形；点位于一条已有边上，就把这条边所在的两个三角形分裂成四个三角形。在每种情况的最后，还要进行边翻转的操作（下一节详细介绍）。具体代码如下：

```c++
    void TriangleList::addPoint(const std::vector<Vector2f>& pointSet, const int& index, TriangleTree& tree){
        Vector2f point = pointSet[index];
        std::vector<std::shared_ptr<ListNode>> ptrVec;
        findTriangle(index, tree.root, ptrVec, pointSet);
        if(ptrVec.size() == 1) {
            std::shared_ptr<ListNode> ptr = ptrVec[0];
            int ind0 = ptr->tri_v0, ind1 = ptr->tri_v1, ind2 = ptr->tri_v2;
            std::shared_ptr<TreeNode> current_treenode = ptr->treenode;
            std::shared_ptr<ListNode> new_listnode0(new ListNode(index, ind0, ind1));
            std::shared_ptr<ListNode> new_listnode1(new ListNode(index, ind1, ind2));
            std::shared_ptr<ListNode> new_listnode2(new ListNode(index, ind2, ind0));
            std::shared_ptr<TreeNode> new_treenode0(new TreeNode(index, ind0, ind1));
            std::shared_ptr<TreeNode> new_treenode1(new TreeNode(index, ind1, ind2));
            std::shared_ptr<TreeNode> new_treenode2(new TreeNode(index, ind2, ind0));
            linkEdge(new_listnode0);
            linkEdge(new_listnode1);
            linkEdge(new_listnode2);
            crossLink(new_listnode0, new_treenode0);
            crossLink(new_listnode1, new_treenode1);
            crossLink(new_listnode2, new_treenode2);
            current_treenode->childNum = 3;
            current_treenode->child0 = new_treenode0;
            current_treenode->child1 = new_treenode1;
            current_treenode->child2 = new_treenode2;
            if(ptr->pre == nullptr) 
                head = new_listnode0;
            else {
                ptr->pre->next = new_listnode0;
                new_listnode0->pre = ptr->pre;
            }
            new_listnode0->next = new_listnode1;
            new_listnode1->pre = new_listnode0;
            new_listnode1->next = new_listnode2;
            new_listnode2->pre = new_listnode1;
            new_listnode2->next = ptr->next;
            if(new_listnode2->next != nullptr)
                new_listnode2->next->pre = new_listnode2;
            unlinkEdge(ptr);
            ptr.reset();
            legalizeEdge(index, ind0, ind1, pointSet);
            legalizeEdge(index, ind1, ind2, pointSet);
            legalizeEdge(index, ind2, ind0, pointSet);
        }
        else if(ptrVec.size() == 2) {
            std::shared_ptr<ListNode> ptr0 = ptrVec[0], ptr1 = ptrVec[1];
            int ind00 = ptr0->tri_v0, ind01 = ptr0->tri_v1, ind02 = ptr0->tri_v2;
            int ind10 = ptr1->tri_v0, ind11 = ptr1->tri_v1, ind12 = ptr1->tri_v2;
            std::vector<int> tmpInd0; // points that are used twice
            std::vector<int> tmpInd1; // points that are used once
            if(ind00 == ind10 || ind00 == ind11 || ind00 == ind12)  tmpInd0.push_back(ind00);
            else tmpInd1.push_back(ind00);
            if(ind01 == ind10 || ind01 == ind11 || ind01 == ind12)  tmpInd0.push_back(ind01);
            else tmpInd1.push_back(ind01);
            if(ind02 == ind10 || ind02 == ind11 || ind02 == ind12)  tmpInd0.push_back(ind02);
            else tmpInd1.push_back(ind02);
            if(tmpInd1[0] == ind01)
                std::swap(tmpInd0[0], tmpInd0[1]);
            if(ind10 != ind00 && ind10 != ind01 && ind10 != ind02)  tmpInd1.push_back(ind10);
            else if(ind11 != ind00 && ind11 != ind01 && ind11 != ind02)  tmpInd1.push_back(ind11);
            else tmpInd1.push_back(ind12);
            std::shared_ptr<TreeNode> current_treenode0 = ptr0->treenode, current_treenode1 = ptr1->treenode;
            std::shared_ptr<ListNode> new_listnode00(new ListNode(index, tmpInd1[0], tmpInd0[0]));
            std::shared_ptr<ListNode> new_listnode01(new ListNode(index, tmpInd0[1], tmpInd1[0]));
            new_listnode00->next = new_listnode01;
            new_listnode01->pre = new_listnode00;
            std::shared_ptr<ListNode> new_listnode10(new ListNode(index, tmpInd0[0], tmpInd1[1]));
            std::shared_ptr<ListNode> new_listnode11(new ListNode(index, tmpInd1[1], tmpInd0[1]));
            new_listnode10->next = new_listnode11;
            new_listnode11->pre = new_listnode10;
            std::shared_ptr<TreeNode> new_treenode00(new TreeNode(index, tmpInd1[0], tmpInd0[0]));
            std::shared_ptr<TreeNode> new_treenode01(new TreeNode(index, tmpInd0[1], tmpInd1[0]));
            std::shared_ptr<TreeNode> new_treenode10(new TreeNode(index, tmpInd0[0], tmpInd1[1]));
            std::shared_ptr<TreeNode> new_treenode11(new TreeNode(index, tmpInd1[1], tmpInd0[1]));
            linkEdge(new_listnode00);
            linkEdge(new_listnode01);
            linkEdge(new_listnode10);
            linkEdge(new_listnode11);
            crossLink(new_listnode00, new_treenode00);
            crossLink(new_listnode01, new_treenode01);
            crossLink(new_listnode10, new_treenode10);
            crossLink(new_listnode11, new_treenode11);
            current_treenode0->childNum = 2;
            current_treenode0->child0 = new_treenode00;
            current_treenode0->child1 = new_treenode01;
            current_treenode1->childNum = 2;
            current_treenode1->child0 = new_treenode10;
            current_treenode1->child1 = new_treenode11;
            if(ptr0->pre == nullptr)
                head = new_listnode00;
            else {
                ptr0->pre->next = new_listnode00;
                new_listnode00->pre = ptr0->pre;
            }
            if(ptr1->pre == nullptr)
                head = new_listnode10;
            else {
                ptr1->pre->next = new_listnode10;
                new_listnode10->pre = ptr1->pre;
            }
            new_listnode01->next = ptr0->next;
            if(new_listnode01->next != nullptr)
                new_listnode01->next->pre = new_listnode01;
            new_listnode11->next = ptr1->next;
            if(new_listnode11->next != nullptr)
                new_listnode11->next->pre = new_listnode11;
            unlinkEdge(ptr0);
            unlinkEdge(ptr1);
            ptr0.reset();
            ptr1.reset();
            legalizeEdge(index, tmpInd0[0], tmpInd1[0], pointSet);
            legalizeEdge(index, tmpInd0[0], tmpInd1[1], pointSet);
            legalizeEdge(index, tmpInd0[1], tmpInd1[0], pointSet);
            legalizeEdge(index, tmpInd0[1], tmpInd1[1], pointSet);
        }
    }
```

#### 如何进行边的翻转

在上面addPoint()函数中，添加完点并处理好链表顺序后就需要对新添加的边进行合规化处理。要做到这一点，首先需要利用到记录了每条边存储的三角形链表节点的二维数组edgeTable，在添加边和删除边的时候修改对应位置的元素（因为每条边最多对应两个三角形，所以这里的空间开销是$O(n^2)$大小的）。有了这个结构，我们就可以根据边的顶点得到其所在的三角形，进一步还可以分出属于这条边的两个顶点和另两个顶点。下一步我们要判断这条边是否合规。

首先，如果这条边所在的两个三角形组成的是一个凹四边形，那么是不需要判断的。判断是否为凸四边形的方法也很简单，就是判断两个对角的顶点是否在另一对顶点组成的边的同侧：

```c++
    bool isConvex(int indr, int ind0, int ind1, int indl, const std::vector<Vector2f>& pointSet){
        bool flag0, flag1;
        flag0 = isLeft(ind0, indr, indl, pointSet);
        flag1 = isLeft(ind1, indr, indl, pointSet);
        return flag0 == flag1;
    }
```

在确认了组成的是凸四边形后，通过比对两个对角的余弦值关系，就可以确定检测的边是否合规：

```c++
    bool isLegal(int indr, int ind0, int ind1, int indl, const std::vector<Vector2f>& pointSet) {
        if(ind0 <= 0 && ind1 <= 0) return true;
        // is convex quadrilateral
        bool flag0, flag1;
        flag0 = isLeft(ind0, indr, indl, pointSet);
        flag1 = isLeft(ind1, indr, indl, pointSet);
        if(flag0 == flag1) return true;

        if(indr < 0 || ind0 < 0 || ind1 < 0 || indl < 0) {
            if(indr >= 0 && indl >= 0)  return false;
            else return true;
            if(ind0 >= 0 && ind1 >= 0)  return true;
        }

        Vector2f pr = pointSet[indr], p0 = pointSet[ind0], p1 = pointSet[ind1], pl = pointSet[indl];
        float angleCosine0 = dotProduct(p0 - pr, p1 - pr) / ((p0 - pr).norm() * (p1 - pr).norm());
        float angleCosine1 = dotProduct(p0 - pl, p1 - pl) / ((p0 - pl).norm() * (p1 - pl).norm());
        if(-angleCosine0 > angleCosine1) return false;
        return true;
    }
```

对于需要翻转的边，合规化函数将要完成如下几件事：撤除原有的三角形；添加新的三角形；递归调用本身判断其他边。总体的代码如下：

```c++
inline void TriangleList::legalizeEdge(const int indr, const int ind0, const int ind1, const std::vector<Vector2f>& pointSet) {
    if(edgeTable[ind0 + 2][ind1 + 2].size() < 2) return;
    std::shared_ptr<ListNode> ptr0 = edgeTable[ind0 + 2][ind1 + 2][0], ptr1 = edgeTable[ind0 + 2][ind1 + 2][1];
    int indl;
    if(indr != ptr0->tri_v0 && indr != ptr0->tri_v1 && indr != ptr0->tri_v2)
        std::swap(ptr0, ptr1); // indr is in ptr0->tri
    if(ptr1->tri_v0 != ind0 && ptr1->tri_v0 != ind1)    indl = ptr1->tri_v0;
    else if(ptr1->tri_v1 != ind0 && ptr1->tri_v1 != ind1)    indl = ptr1->tri_v1;
    else    indl = ptr1->tri_v2;
    if(isLegal(indr, ind0, ind1, indl, pointSet)) return;

    std::shared_ptr<TreeNode> current_treenode0 = ptr0->treenode, current_treenode1 = ptr1->treenode;
    std::shared_ptr<ListNode> new_listnode0, new_listnode1;
    std::shared_ptr<TreeNode> new_treenode0, new_treenode1;
    if(isLeft(ind1, indr, indl, pointSet)) {
        new_listnode0.reset(new ListNode(indr, indl, ind1));
        new_listnode1.reset(new ListNode(indl, indr, ind0));
        new_treenode0.reset(new TreeNode(indr, indl, ind1));
        new_treenode1.reset(new TreeNode(indl, indr, ind0));
    }
    else {
        new_listnode0.reset(new ListNode(indr, indl, ind0));
        new_listnode1.reset(new ListNode(indl, indr, ind1));
        new_treenode0.reset(new TreeNode(indr, indl, ind0));
        new_treenode1.reset(new TreeNode(indl, indr, ind1));
    }
    crossLink(new_listnode0, new_treenode0);
    crossLink(new_listnode1, new_treenode1);
    linkEdge(new_listnode0);
    linkEdge(new_listnode1);

    current_treenode0->childNum = 2, current_treenode1->childNum = 2;
    current_treenode0->child0 = new_treenode0, current_treenode0->child1 = new_treenode1;
    current_treenode1->child0 = new_treenode0, current_treenode1->child1 = new_treenode1;

    if(ptr0->pre == nullptr)
        head = new_listnode0;
    else {
        ptr0->pre->next = new_listnode0;
        new_listnode0->pre = ptr0->pre;
    }
    if(ptr1->pre == nullptr)
        head = new_listnode1;
    else {
        ptr1->pre->next = new_listnode1;
        new_listnode1->pre = ptr1->pre;
    }
    new_listnode0->next = ptr0->next;
    if(new_listnode0->next != nullptr)
        new_listnode0->next->pre = new_listnode0;
    new_listnode1->next = ptr1->next;
    if(new_listnode1->next != nullptr)
        new_listnode1->next->pre = new_listnode1;
    unlinkEdge(ptr0);
    unlinkEdge(ptr1);
    std::shared_ptr<ListNode> ptr = head;
    ptr0.reset();
    ptr1.reset();
    legalizeEdge(indr, ind0, indl, pointSet);
    legalizeEdge(indr, ind1, indl, pointSet);
}
```

### 设计3：画图API的调用

这部分的内容参考了GAMES101的作业07，利用opencv这个开源库，然后进行了相应的绘制。值得注意的是，在opencv提供的画图窗口，默认是左上角为原点，向右为x轴正方向，向下为y轴正方向，因此在利用鼠标事件获取点坐标和进行图形绘制的时候，都要做一个变换：

```c++
    // Deal with mouse event
    void mouse_handler(int event, int x, int y, int flags, void *userdata) 
    {
        if (event == cv::EVENT_LBUTTONDOWN)
        {
            std::cout << "Left button of the mouse is clicked - position (" << x << ", "
            << height - y << ")" << '\n';
            pointSet.emplace_back(x, height - y);
        }     
    }
```

```c++
    // Render per pixel
void setPixel(const float& x, const float& y, cv::Point3f color = cv::Point3f(255, 255, 255)) {
    if(x + 0.5 > width || x < 0)    return;
    if(y + 0.5 > height || y < 0)    return;
    window.at<cv::Vec3b>(height - y - 0.5, x + 0.5)[0] = color.x;
    window.at<cv::Vec3b>(height - y - 0.5, x + 0.5)[1] = color.y;
    window.at<cv::Vec3b>(height - y - 0.5, x + 0.5)[2] = color.z;
}
```

### 经验与教训

1. 在开始写代码的时候一定要先考虑清楚算法的正确性，避免出现先把全部内容都写完之后再回过头一点点检查
2. 当处理各种点、边关系的时候，可以通过传入对应的 __索引__ 而非具体点，这样可以节省很多处理的时间；
3. 对于边的存储格式，完全可以利用邻接矩阵，这比哈希表好用
4. 处理链表的连接关系的时候，记得考虑如果ptr->next == null的情况，此时如果直接做ptr->next->pre = ptr，就会发生段错误
5. 利用智能指针而非原始指针来避免发生内存泄漏的问题
6. 先声明再定义可以一定程度上避免交叉引用发生问题，但是对与类内新定义的结构体，即使先声明再定义，仍然会出现问题。这个时候就不能够在类内定义，而是先定义好了结构体之后（仍然要先声明）再在需要的类里面定义这个结构体类型的变量。
