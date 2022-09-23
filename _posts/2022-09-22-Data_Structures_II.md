---
layout: post
title: Data Structures II
date: 2022-09-22 12:55 +0800
tags: [learning, data_structure]
toc: true
---

# Lesson 02: Linked list

In order to avoid the linear cost of insertion and deletion, we need to ensure that the list is not stored contiguously, which introduces the idea of **linked list**.

[A blog helps you understand linked list](https://towardsdatascience.com/how-i-taught-myself-linked-lists-72c4837ea721)

A program about address

```
// test.cpp
#include<iostream>
#include<limits>

int main()
{
  int *a;
  double *b;
  a = new(int);
  b = new(double);
  *a = 1; 
  *b = 3.14;
  std::cout << a << ", a + 1 = " << a + 1 << std::endl;
  std::cout << b << ", b + 1 = " << b + 1 << std::endl;  
  return 0;
}

```


```
#include<iostream>
#include<limits>

template <typename DT>
class Node{
public:
  DT data;
  Node* next;
  DT get_data();
}

tmplate<typename DT>
DT Node<DT>::get_data(){
        return data;
}

int main()
{

  Node<int> n;

  int *a;
  double *b;
  a = new(int);
  b = new(double);
  *a = 1; 
  *b = 3.14;
  std::cout << a << ", a + 1 = " << a + 1 << std::endl;
  std::cout << b << ", b + 1 = " << b + 1 << std::endl;  
  return 0;
}

```

- Ops of linked list(Actually still a ADT List!!)

|Function|Action|TimeConsuming|
|:---|:---|:---|
|insert(dat)|insert *dat* at the end|O(1)|
|delete()|delete(pop) the first *dat*|O(1)|
|find(dat)|find if *dat* exist|O(n)|

When implement the functions, notice that **single linked list** cannot share the class *Node* with **DoubleLinkedList**. A optional way to fix this problem is to place the class *Node* into class *SingleLinkedList*, which avoids being used by other class.

```


```

Question appears! Where to insert? So we should add more properties into our linked list class.

```

```

Don't forget to add necessary comments explaining your code.

```

```

Add *remove()* function

```

```

Remember to add destructor into *SingleLinkedlist* class.

```

```
