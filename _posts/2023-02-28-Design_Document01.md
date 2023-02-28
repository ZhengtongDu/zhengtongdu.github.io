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

> 理论及算法的介绍：请参见[这里][delaunaytriangulation]

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

#### 如何添加新的点到已有三角形节点链表中？

#### 如何进行边的翻转

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
