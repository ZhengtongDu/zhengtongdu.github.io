---
layout: post
title: coding_standard
date: 2023-07-31 00:26 +0800
tags: ["Learning Notes", "Single Notes"]
toc: true
---

> 记录编程相关约定俗成的规则。

## 编程规范

> 旨在通过强制性的规则保证自己代码风格统一，参考了实习公司的开发规范文档

### 环境编码相关

- 所有代码必须以UTF-8作为编码；
- 正式的c++项目，除非有特殊原因，都必须以CMake来组织工程；
- 制表符设置为4个空格。

### C++命名规则（也应用到其他语言代码中）

- 类、结构体的名字大写开头，然后驼峰形式；
- 类的成员变量以m_开头，然后是小写字母开头的驼峰形式；
- 其他变量均为小写字母开头的驼峰形式；
- 类的成员函数为小写字母开头的驼峰形式。

例：

```c++
class MyClass : public A
{
public:
    MyClass() {}
    ~MyClass();

    void f(std::string);
    int calcAbs();

private:
    int m_x;
    std::string m_name;
};

int main()
{
    MyClass a;
    double opX, opY;
    std::string myName;
    f(myName);

    return 0;
}
```

## GIT提交规范

> 用来掌握基本的git提交规范，内容来自[阮一峰](http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)的《Commit message和Change log编写指南》

### Commit message的格式

每次提交，Commit message 都包括三个部分：Header，Body 和 Footer（Body和Footer可以忽略）。

```html
<type>(<scope>): <subject>
// 空一行
<body>
// 空一行
<footer>
```

具体说明Header：

- type（必需）  ：用于说明commit的类别，包含如下7个标识（常用的是前两个）：
  - feat：新功能（feature）
  - fix：修补bug
  - docs：文档（documentation）
  - style： 格式（不影响代码运行的变动）
  - refactor：重构（即不是新增功能，也不是修改bug的代码变动）
  - test：增加测试
  - chore：构建过程或辅助工具的变动
- scope（可选）  ：用于说明 commit 影响的范围，比如数据层、控制层、视图层等等，视项目不同而不同。
- subject（必需）：是 commit 目的的简短描述，不超过50个字符
