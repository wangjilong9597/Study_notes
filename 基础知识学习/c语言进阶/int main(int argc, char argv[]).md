

# **int main(int argc, char \*argv[])**



## **1.什么情况下用int main(int argc, char \*argv[]) 。**

我们需要和程序进行交互。你知道，在程序运行过程中，可以通过scanf函数，输入数组、字符、字符串给程序处理。

那么能不能在程序启动的时候（），就携带参数给他，而不是运行过程中敲入东西给程序。这时候需要用用到带参数(int argc, char *argv[])的main函数。



你很可能用过ping命令，去ping一个IP地址，比如：ping 192.168.0.1



其实这个里的ping就是一个exe程序，"192.168.0.1"是一个字符串，是我们传递给程序的参数。



所以，当你需要程序带参数地启动的时候，就用int main(int argc, char *argv[])。



**2.怎么使用argc和argv参数。**



你可能会想，argc和argv是传给main函数的参数。那这个参数是谁传的？main函数不是已经是入口函数了吗？还有别的函数调用main函数？



argc和argv是你通过命令行窗口传给程序的。



你先猜猜下面的程序运行结果是什么？



```c
#include <stdio.h>
int main(int argc , char *argv[])
{
    printf("argc = %d\n", argc);
    printf("%s\n", *argv);    
}
```



我们编译运行，结果如下。有没有发现，*argv是字符串，字符串的内容是exe程序文件名（包括它的完整路径）。



![img](int main(int argc, char argv[]).assets/v2-3356895f884e36e22224d79e354e099c_720w.webp)

argc = 1，这个表示什么？表示的是命令行有1个字符串，这个字符串是"D\test\main_arg_argv.exe"，也就是我们的程序名。

你可能会想：

（1）那怎么通过命令行给程序传递字符串呢？

（2）程序是怎么样获取到传递来的字符串呢？



答案是：

（1）用这样的格式给程序传递字符串：

程序名.exe 字符串1 字符串2 字符串3 ... 字符串n

执行exe程序时，你可以在.exe名字后面加上任意多个字符串。每个字符串用空格隔开。



（2）在main函数里通过循环依次一个个地来接收字符串。



举个例子：



我们来做这样一个程序：

要求：

传递的某个字符串等于"Aa"就打印"A for apple"，传递的某个字符串里等于"Bb"就输出"B for ball"，传递的某个字符串等于"Cc"就输出"C for ball"，传递的某个字符串等于"Dd"就输出"D for dog".



先上代码：



```c
#include <stdio.h>
#include <string.h>

int main(int argc , int *argv[])
{
    printf("argc = %d\n", argc);

    argv++;
    while (*argv){
        if (strcmp(*argv, "Aa") == 0){
            argv++;
            printf("A for apple\n");

        }else if (strcmp(*argv, "Bb") == 0){
            argv++;
            printf("B for ball\n");

        }else if (strcmp(*argv, "Cc") == 0){
            argv++;
            printf("C for cat\n");

        }else if (strcmp(*argv, "Dd") == 0){
                printf("in d\n");
            argv++;
            printf("D for dog\n");
        }
    }
}
```



注意这个时候，我们就不能直接在编辑器里直接运行程序，因为这样自动运行是没有参数的。



点下图中的编译按钮。然后进入源文件所在文件夹：D:\test。可以看到生成了一个文件名叫main_argc_argv.exe，这个就是编译生成的可执行文件，俗称“程序/软件”。



![img](int main(int argc, char argv[]).assets/v2-3ea84a6ed2b5a73f1257345597f63313_720w.webp)



D:\test\main_argc_argv.exe



![img](int main(int argc, char argv[]).assets/v2-4388b2b94f1ae770736a8369e7f70579_720w.webp)



那么怎么运行呢？

打开命令行，鼠标左键选中.exe文件，拖+到cmd窗口中：



![img](int main(int argc, char argv[]).assets/v2-1869ede62211232bac5792f6d9e6260f_720w.webp)



然后在后面加上我们想要加的字符串。这里加上"Cc"和"Aa"



![img](int main(int argc, char argv[]).assets/v2-a145fa9d94776ec96d9c5a6015198e60_720w.png)

然后，按回车键运行。



![img](int main(int argc, char argv[]).assets/v2-999e3972a22bee800a70861b6345b975_720w.webp)

如我们所期望的，命令行我们敲参数时，Cc在Aa前面，所以先打印出"C for cat"，后打出"A for apple"。

注意：这里的argc是3，表示的是什么呢？

之前我们说过，arrgc=1时，表示命令行只有一个字符串，是程序名"D\test\main_arg_argv.exe"。

3表示命令行有3个字符串，分别是：程序名"D\test\main_arg_argv.exe"、"Cc"和"Aa"。



这下你应该明白怎么使用main函数中的参数了。



**3.总结**



当你需要程序带参数地启动的时候，就用int main(int argc, char *argv[])。