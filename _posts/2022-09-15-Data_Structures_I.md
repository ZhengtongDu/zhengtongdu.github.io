---
layout: post
title: Data Structures I
date: 2022-09-15 13:51 +0800
tags: [learning, data_structure]
toc: true
---
Just a note example, better way to learn it is watching course videos.

# Lesson 01: ADTList Implementation

ADT(Abstract Data Type)List: A set of objects together with a set of operations

Some notations: The size of list is *N*, **empty list** when *N = 0*;

- Operations of List:

|function| description|
|:---|:---|
|printList()|build a list *L*|
|makeEmpty(*L*)|make list *L* empty|
|findKth(*pos*)|find the *pos*th element|
|insert(*pos*, *x*)|insert *x* at *pos*|
|remove(*x*)|delete the element *x*|
|next(*pos*)|return the position of *pos*th element's successor|
|previous(*pos*)|return the position of *pos*th element's predecessor|


- Simple implementation

It's the first time to write a cpp-class...
```
class ADTList
{
  double *data;
  int size;
}
```

Hold on! How to create a cpp file and edit it when you face so clear terminal?

```
$ emacs main.cpp
Maybe you should install it.
$ sudo apt-get install emacs
```

- There are three main text editors used in the linux(ubuntu): Emacs / Vim / VS-Code. Now you can use one of them to create *main.cpp* file and edit it.

```
//main.cpp
#include <iostream>

int main(int argc, int *argv[])
{
        std::cout << "Hello world!" << std::endl;
        return 0;
}
```

Back to terminal(or directly work on Emacs) and compile the file:

```
$ g++ -o main main.cpp
$ ./main
```
You will see "Hello world!" in your terminal.

OK, we'll add more details:

```
//main.cpp
#include <iostream>

class ADTList
{
private:
  double *data;
  int size;
public:
  void makeEmpty();
}

int main(int argc, char *argv[])
{
  ADTList A;
  A.makeEmpty();

  std::cout << "Hello world!" << std::endl;
  return 0;
}
```

Attention! You should intialize the element of *A* before doing other things!

- Construtor

```
public:
ADTList() // No return value (which is different from void)
{
  data = nullptr;
  size = 0;
}
```

**using gdb to dubug**

If you want the constructor offers other service for you to create a object like this:

```
  ADTList A{15, 20, 1, 23}; 
```
You should link another library *<intializer_list>*, [click it and see more about it.](https://cplusplus.com/reference/initializer_list/initializer_list/initializer_list/)

```
//main.cpp
#include <iostream>
#include <initializer_list>

class ADTList
{
private:
  double *data;
  int size;
public:

  ADTList()
  {
    data = nullptr;
    size = 0;
  }
  
  ADTList(std::initializer_list<double> _list);

  void makeEmpty();
};

ADTList::ADTList(std::initializer_list<double> _list)
{
    ~ADTlist(); // Destructor, similiar to constructor

ADTList::~ADTList()
{
  if (data != nullptr)
     delete [] data;
}

ADTList::makeEmtpy()
{
  if (data != nullptr)
     delete [] data;
  size = 0;
}

```

One more step! Using a private function to replace the same piece, make it a inline function to boost efficiency.

```
private:
  inline void _empty()
  {
    if (data != nullptr)
       delete [] data;
  }
public:
  ~ADTList();

ADTList::~ADTList()
{
  _empty();
}

ADTList::makeEmtpy()
{
  _empty();
  size = 0;
}

```

- You can also use **valgrind** to check if memory leak exists.

```
$ g++ -o main main.cpp
$ valgrind ./main
```

- Add a **real** function *insert(int _p, double _v)*:

```
void ADTList::insert(int _p, double _v)
{
    
  double *data_new = new double [size + 1];
  int i = 0;
  for (; i < _p - 1; i++)
    data_new[i] = data[i];
  data_new[i] = _v;
  for (; i< size; i++)
    data_new[i+1] = data[i];
  _empty();
  data = data_new;
  size = size+1;
}
```

If the client programmer wants to insert a new element at an **illegal** position, the program should return an error message:
```
  if(_p >= size || _p <0)
    {
      std::cout << "Out of range" << std::endl;
      std::exit(2);
    }
```
(How to check the error code? You can use shell command like this:

```
$ echo $?
```
If "out of rage" happens, terminal will return the error code "2".
)

- The remain functions are similiar to *insert(int _p, double _v)*, try to write it. The following is the code mentioned in this lesson:

```
//main.cpp
#include <iostream>
#include <initializer_list>

class ADTList
{
private:
  double *data;
  int size;
  void _empty()
  {
    if (data != nullptr)
      delete [] data;
  }
public:

  ADTList()
  {
    data = nullptr;
    size = 0;
  }
  
  ADTList(std::initializer_list<double> _list);
  ~ADTList();
  
  void makeEmpty();
  void printList();
  bool is_empty();
  void insert(int _p, double _v);
};

ADTList::ADTList(std::initializer_list<double> _list)
{
  size = _list.size();
  data = new double[size];
  int i = 0;
  for (double x : _list){
    data[i] = x;
    i++;
  }
};

ADTList::~ADTList()
{
  _empty();
};

void ADTList::makeEmpty()
{
  _empty();
  size = 0;
};

void ADTList::printList()
{
  for (int i = 0; i < size; i++)
    std::cout << data[i] << "  ";
  std::cout << std::endl;
};

bool ADTList::is_empty()
{
  return (size == 0);
};

void ADTList::insert(int _p, double _v)
{
  if(_p >= size || _p <0)
    {
      std::cout << "Out of range" << std::endl;
      std::exit(2);
    }
    
  double *data_new = new double [size + 1];
  int i = 0;
  for (; i < _p - 1; i++)
    data_new[i] = data[i];
  data_new[i] = _v;
  for (; i< size; i++)
    data_new[i+1] = data[i];
  _empty();
  data = data_new;
  size = size+1;
}


int main(int argc, char *argv[])
{
  ADTList A{1,2,3};
  A.printList();
  A.insert(2, 4);
  // A.insert(4, 4); // Error happens!
  A.printList();
  return 0;
}

```


