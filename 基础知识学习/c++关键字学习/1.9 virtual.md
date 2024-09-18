# virtual那些事

## 1.虚函数与运行多态

```cpp
#include <iostream>
using namespace std;

class Employee {
public:
  virtual void raiseSalary() { cout << 0 << endl; }

  virtual void promote() { /* common promote code */
  }
};

class Manager : public Employee {
  virtual void raiseSalary() { cout << 100 << endl; }

  virtual void promote() { /* Manager specific promote */
  }
};
class Engineer : public Employee {
  virtual void raiseSalary() { cout << 200 << endl; }

  virtual void promote() { /* Manager specific promote */
  }
};

// Similarly, there may be other types of employees
// We need a very simple function to increment salary of all employees
// Note that emp[] is an array of pointers and actual pointed objects can
// be any type of employees. This function should ideally be in a class
// like Organization, we have made it global to keep things simple
void globalRaiseSalary(Employee *emp[], int n) {
  for (int i = 0; i < n; i++)
    emp[i]->raiseSalary(); // Polymorphic Call: Calls raiseSalary()
                           // according to the actual object, not
                           // according to the type of pointer
}
int main() {
  Employee *emp[] = {new Manager(), new Engineer};
  globalRaiseSalary(emp, 2);
  return 0;
}
```

对应的代码：[emp.cpp](./set1/emp.cpp)

**虚函数的调用取决于指向或者引用的对象的类型，而不是指针或者引用自身的类型。**

## 2.vptr与vtable

见 `1.8 虚函数的vptr与vtable3.虚函数中默认参数`

```cpp
/**
 * @file first_example.cpp
 * 虚函数中默认参数
 * 规则：虚函数是动态绑定的，默认参数是静态绑定的。默认参数的使用需要看指针或者应用本身的类型，而不是对象的类型！
 */

#include <iostream>
using namespace std;

class Base {
public:
  virtual void fun(int x = 10) { cout << "Base::fun(), x = " << x << endl; }
};

class Derived : public Base {
public:
  virtual void fun(int x = 20) { cout << "Derived::fun(), x = " << x << endl; }
};

int main() {
  Derived d1;
  Base *bp = &d1;
  bp->fun(); // 10
  return 0;
}
```

对应的代码：[default_arg.cpp](./set2/default_arg.cpp)

**默认参数是静态绑定的，虚函数是动态绑定的。 默认参数的使用需要看指针或者引用本身的类型，而不是对象的类型**。

## 4.可以不可以

（1） **静态函数可以声明为虚函数吗？**

原因主要有两方面：

**静态函数不可以声明为虚函数，同时也不能被const 和 volatile关键字修饰**

static成员函数不属于任何类对象或类实例，所以即使给此函数加上virutal也是没有任何意义

虚函数依靠vptr和vtable来处理。vptr是一个指针，在类的构造函数中创建生成，并且只能用this指针来访问它，静态成员函数没有this指针，所以无法访问vptr。

代码学习：[static_error.cpp  ](./set3/static_error.cpp  )

（2）**构造函数可以为虚函数吗？**

构造函数不可以声明为虚函数。同时除了inline|explicit之外，构造函数不允许使用其它任何关键字。

为什么构造函数不可以为虚函数？

尽管虚函数表vtable是在编译阶段就已经建立的，但指向虚函数表的指针vptr是在运行阶段实例化对象时才产生的。 如果类含有虚函数，编译器会在构造函数中添加代码来创建vptr。 问题来了，如果构造函数是虚的，那么它需要vptr来访问vtable，可这个时候vptr还没产生。 因此，构造函数不可以为虚函数。

我们之所以使用虚函数，是因为需要在信息不全的情况下进行多态运行。而构造函数是用来初始化实例的，实例的类型必须是明确的。 因此，构造函数没有必要被声明为虚函数。

代码学习：

```cpp
#include <iostream>
using namespace std;

class Base {
public:
};

class Derived : public Base {
public:
  Derived() { cout << "Derived created" << endl; }

  Derived(const Derived &rhs) {
    cout << "Derived created by deep copy" << endl;
  }

  ~Derived() { cout << "Derived destroyed" << endl; }
};

int main() {
  Derived s1;

  Derived s2 = s1; // Compiler invokes "copy constructor"
  // Type of s1 and s2 are concrete to compiler

  // How can we create Derived1 or Derived2 object
  // from pointer (reference) to Base class pointing Derived object?

  return 0;
}

```

- [copy_consrtuct.cpp](./set3/copy_consrtuct.cpp) 

```cpp
/**
 * @file vir_con.cpp
 * 构造函数不可以声明为虚函数。同时除了inline之外，构造函数不允许使用其它任何关键字。
 *
 * 为什么构造函数不可以为虚函数？
 *
 * 尽管虚函数表vtable是在编译阶段就已经建立的，但指向虚函数表的指针vptr是在运行阶段实例化对象时才产生的。
 * 如果类含有虚函数，编译器会在构造函数中添加代码来创建vptr。
 * 问题来了，如果构造函数是虚的，那么它需要vptr来访问vtable，可这个时候vptr还没产生。
 * 因此，构造函数不可以为虚函数。
 * 我们之所以使用虚函数，是因为需要在信息不全的情况下进行多态运行。而构造函数是用来初始化实例的，实例的类型必须是明确的。
 * 因此，构造函数没有必要被声明为虚函数。
 * 尽管构造函数不可以为虚函数，但是有些场景下我们确实需要 “Virtual Copy
 * Constructor”。
 * “虚复制构造函数”的说法并不严谨，其只是一个实现了对象复制的功能的类内函数。
 * 举一个应用场景，比如剪切板功能。
 * 复制内容作为基类，但派生类可能包含文字、图片、视频等等。
 * 我们只有在程序运行的时候才知道我们需要复制的具体是什么类型的数据。
 */

#include <iostream>
using namespace std;

//// LIBRARY SRART
class Base {
public:
  Base() {}

  virtual // Ensures to invoke actual object destructor
      ~Base() {}

  virtual void ChangeAttributes() = 0;

  // The "Virtual Constructor"
  static Base *Create(int id);

  // The "Virtual Copy Constructor"
  virtual Base *Clone() = 0;
};

class Derived1 : public Base {
public:
  Derived1() { cout << "Derived1 created" << endl; }

  Derived1(const Derived1 &rhs) {
    cout << "Derived1 created by deep copy" << endl;
  }

  ~Derived1() { cout << "~Derived1 destroyed" << endl; }

  void ChangeAttributes() { cout << "Derived1 Attributes Changed" << endl; }

  Base *Clone() { return new Derived1(*this); }
};

class Derived2 : public Base {
public:
  Derived2() { cout << "Derived2 created" << endl; }

  Derived2(const Derived2 &rhs) {
    cout << "Derived2 created by deep copy" << endl;
  }

  ~Derived2() { cout << "~Derived2 destroyed" << endl; }

  void ChangeAttributes() { cout << "Derived2 Attributes Changed" << endl; }

  Base *Clone() { return new Derived2(*this); }
};

class Derived3 : public Base {
public:
  Derived3() { cout << "Derived3 created" << endl; }

  Derived3(const Derived3 &rhs) {
    cout << "Derived3 created by deep copy" << endl;
  }

  ~Derived3() { cout << "~Derived3 destroyed" << endl; }

  void ChangeAttributes() { cout << "Derived3 Attributes Changed" << endl; }

  Base *Clone() { return new Derived3(*this); }
};

// We can also declare "Create" outside Base.
// But is more relevant to limit it's scope to Base
Base *Base::Create(int id) {
  // Just expand the if-else ladder, if new Derived class is created
  // User need not be recompiled to create newly added class objects

  if (id == 1) {
    return new Derived1;
  } else if (id == 2) {
    return new Derived2;
  } else {
    return new Derived3;
  }
}
//// LIBRARY END

//// UTILITY SRART
class User {
public:
  User() : pBase(0) {
    // Creates any object of Base heirarchey at runtime

    int input;

    cout << "Enter ID (1, 2 or 3): ";
    cin >> input;

    while ((input != 1) && (input != 2) && (input != 3)) {
      cout << "Enter ID (1, 2 or 3 only): ";
      cin >> input;
    }

    // Create objects via the "Virtual Constructor"
    pBase = Base::Create(input);
  }

  ~User() {
    if (pBase) {
      delete pBase;
      pBase = 0;
    }
  }

  void Action() {
    // Duplicate current object
    Base *pNewBase = pBase->Clone();

    // Change its attributes
    pNewBase->ChangeAttributes();

    // Dispose the created object
    delete pNewBase;
  }

private:
  Base *pBase;
};

//// UTILITY END

//// Consumer of User (UTILITY) class
int main() {
  User *user = new User();

  user->Action();

  delete user;
}

```

- [vir_con.cpp](./set3/vir_con.cpp) 

（3）**析构函数可以为虚函数吗？**

**析构函数可以声明为虚函数。如果我们需要删除一个指向派生类的基类指针时，应该把析构函数声明为虚函数。 事实上，只要一个类有可能会被其它类所继承， 就应该声明虚析构函数(哪怕该析构函数不执行任何操作)。**

代码学习：

- [full_virde.cpp](./set3/full_virde.cpp)

```cpp
/**
 * @file full_virde.cpp
 * @brief 将基类的析构函数声明为虚函数
 * 输出结果：
 *      Constructing base
 *      Constructing derived
 *      Destructing derived
 *      Destructing base
 */
#include <iostream>

using namespace std;

class base {
public:
  base() { cout << "Constructing base \n"; }
  virtual ~base() { cout << "Destructing base \n"; }
};

class derived : public base {
public:
  derived() { cout << "Constructing derived \n"; }
  ~derived() { cout << "Destructing derived \n"; }
};

int main(void) {
  derived *d = new derived();
  base *b = d;
  delete b;
  return 0;
}

```

- [vir_de.cpp ](./set3/vir_de.cpp)     

```cpp
/**
 * @file vir_de.cpp
 * @brief 派生类的析构函数没有被调用!
 * 输出结果：
 *      Constructing base
 *      Constructing derived
 *      Destructing base
 */

// CPP program without virtual destructor
// causing undefined behavior
#include <iostream>

using namespace std;

class base {
public:
  base() { cout << "Constructing base \n"; }
  ~base() { cout << "Destructing base \n"; }
};

class derived : public base {
public:
  derived() { cout << "Constructing derived \n"; }
  ~derived() { cout << "Destructing derived \n"; }
};

int main(void) {
  derived *d = new derived();
  base *b = d;
  delete b;
  return 0;
}
```

（4）**虚函数可以为私有函数吗？**

- 基类指针指向继承类对象，则调用继承类对象的函数；
- int main()必须声明为Base类的友元，否则编译失败。 编译器报错： ptr无法访问私有函数。 当然，把基类声明为public， 继承类为private，该问题就不存在了。

代码学习：

- [virtual_function.cpp](./set3/virtual_function.cpp)

```cpp
/**
 * @file virtual_function.cpp
 * @brief 虚函数可以被私有化，但有一些细节需要注意。
 * 基类指针指向继承类对象，则调用继承类对象的函数；
 * int main()必须声明为Base类的友元，否则编译失败。 编译器报错：
 * ptr无法访问私有函数。 当然，把基类声明为public，
 * 继承类为private，该问题就不存在了。----> 见另外一个例子！
 */

#include <iostream>
using namespace std;

class Derived;

class Base {
private:
  virtual void fun() { cout << "Base Fun"; }
  friend int main();
};

class Derived : public Base {
public:
  void fun() { cout << "Derived Fun"; }
};

int main() {
  Base *ptr = new Derived;
  ptr->fun();
  return 0;
}
```

- [virtual_function1.cpp](./set3/virtual_function1.cpp)

```cpp
#include <iostream>
using namespace std;

class Derived;

class Base {
public:
  virtual void fun() { cout << "Base Fun"; }
  //   friend int main();
};

class Derived : public Base {
private:
  void fun() { cout << "Derived Fun"; }
};

int main() {
  Base *ptr = new Derived;
  ptr->fun();
  return 0;
}

```

（5）**虚函数可以被内联吗？**

**通常类成员函数都会被编译器考虑是否进行内联。 但通过基类指针或者引用调用的虚函数必定不能被内联。 当然，实体对象调用虚函数或者静态调用时可以被内联，虚析构函数的静态调用也一定会被内联展开。**

- 虚函数可以是内联函数，内联是可以修饰虚函数的，但是当虚函数表现多态性的时候不能内联。
- 内联是在编译器建议编译器内联，而虚函数的多态性在运行期，编译器无法知道运行期调用哪个代码，因此虚函数表现为多态性时（运行期）不可以内联。
- `inline virtual` 唯一可以内联的时候是：编译器知道所调用的对象是哪个类（如 `Base::who()`），这只有在编译器具有实际对象而不是对象的指针或引用时才会发生。

代码学习：

- [virtual_inline.cpp](./set3/virtual_inline.cpp)

```cpp
/**
 * @file virtual_inline.cpp
 * @brief 通常类成员函数都会被编译器考虑是否进行内联。
 * 但通过基类指针或者引用调用的虚函数必定不能被内联。
 * 当然，实体对象调用虚函数或者静态调用时可以被内联，虚析构函数的静态调用也一定会被内联展开。
 */

#include <iostream>
using namespace std;
class Base {
public:
  virtual void who() { cout << "I am Base\n"; }
};
class Derived : public Base {
public:
  void who() { cout << "I am Derived\n"; }
};

int main() {
  // note here virtual function who() is called through
  // object of the class (it will be resolved at compile
  // time) so it can be inlined.
  Base b;
  b.who();

  // Here virtual function is called through pointer,
  // so it cannot be inlined
  Base *ptr = new Derived();
  ptr->who();

  return 0;
}

```

- [inline_virtual.cpp](./set3/inline_virtual.cpp)

```cpp
#include <iostream>
using namespace std;
class Base {
public:
  inline virtual void who() { cout << "I am Base\n"; }
  virtual ~Base() {}
};
class Derived : public Base {
public:
  inline void who() // 不写inline时隐式内联
  {
    cout << "I am Derived\n";
  }
};

int main() {
  // 此处的虚函数
  // who()，是通过类（Base）的具体对象（b）来调用的，编译期间就能确定了，所以它可以是内联的，但最终是否内联取决于编译器。
  Base b;
  b.who();

  // 此处的虚函数是通过指针调用的，呈现多态性，需要在运行时期间才能确定，所以不能为内联。
  Base *ptr = new Derived();
  ptr->who();

  // 因为Base有虚析构函数（virtual ~Base() {}），所以 delete
  // 时，会先调用派生类（Derived）析构函数，再调用基类（Base）析构函数，防止内存泄漏。
  delete ptr;

  return 0;
}
```

## 5.RTTI与dynamic_cast

RTTI（Run-Time Type Identification)，通过运行时类型信息程序能够使用[基类](https://baike.baidu.com/item/%E5%9F%BA%E7%B1%BB/9589663)的[指针](https://baike.baidu.com/item/%E6%8C%87%E9%92%88/2878304)或引用来检查这些指针或引用所指的对象的实际[派生类](https://baike.baidu.com/item/%E6%B4%BE%E7%94%9F%E7%B1%BB)型。

在面向对象程序设计中，有时我们需要在运行时查询一个对象是否能作为某种多态类型使用。与Java的instanceof，以及C#的as、is运算符类似，C++提供了dynamic_cast函数用于动态转型。相比C风格的强制类型转换和C++ reinterpret_cast，dynamic_cast提供了类型安全检查，是一种基于能力查询(Capability Query)的转换，所以在多态类型间进行转换更提倡采用dynamic_cast。

代码学习：

- [rtti.cpp](./set4/rtti.cpp)

```cpp
/**
 * @file rtti.cpp
 * 在面向对象程序设计中，有时我们需要在运行时查询一个对象是否能作为某种多态类型使用。与Java的instanceof，以及C#的as、is运算符类似，C++提供了dynamic_cast函数用于动态转型。相比C风格的强制类型转换和C++
 * reinterpret_cast，dynamic_cast提供了类型安全检查，是一种基于能力查询(Capability
 * Query)的转换，所以在多态类型间进行转换更提倡采用dynamic_cast
 */

// CPP program to illustrate
// Run Time Type Identification
#include <iostream>
#include <typeinfo>
using namespace std;
class B {
  virtual void fun() {}
};
class D : public B {};

int main() {
  B *b = new D; // 向上转型
  B &obj = *b;
  D *d = dynamic_cast<D *>(b); // 向下转型
  if (d != NULL)
    cout << "works" << endl;
  else
    cout << "cannot cast B* to D*";

  try {
    D &dobj = dynamic_cast<D &>(obj);
    cout << "works" << endl;
  } catch (bad_cast bc) { // ERROR
    cout << bc.what() << endl;
  }
  return 0;
}

```

- [warn_rtti.cpp](./set4/warn_rtti.cpp)

```cpp
// 在使用时需要注意：被转换对象obj的类型T1必须是多态类型，即T1必须公有继承自其它类，或者T1拥有虚函数（继承或自定义）。若T1为非多态类型，使用dynamic_cast会报编译错误。

// A为非多态类型

class A {};

// B为多态类型

class B {

public:
  virtual ~B() {}
};

// D为非多态类型

class D : public A {};

// E为非多态类型

class E : private A {};

// F为多态类型

class F : private B {}

```

## 6.纯虚函数和抽象类

见`1.7 纯虚函数和抽象类`
