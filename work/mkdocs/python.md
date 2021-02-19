### 笔记

元组，列表，字典

元组是只读列表，不能赋值，用()定义

```
#!/usr/bin/python
# -*- coding: UTF-8 -*-
 
tuple = ( 'runoob', 786 , 2.23, 'john', 70.2 )
tinytuple = (123, 'john')
 
print tuple               # 输出完整元组
print tuple[0]            # 输出元组的第一个元素
print tuple[1:3]          # 输出第二个至第四个（不包含）的元素 
print tuple[2:]           # 输出从第三个开始至列表末尾的所有元素
print tinytuple * 2       # 输出元组两次
print tuple + tinytuple   # 打印组合的元组
```

```
('runoob', 786, 2.23, 'john', 70.2)
runoob
(786, 2.23)
(2.23, 'john', 70.2)
(123, 'john', 123, 'john')
('runoob', 786, 2.23, 'john', 70.2, 123, 'john'
```

列表是有序的对象集合，可以更新赋值，用[]定义

Python 列表截取可以接收第三个参数，参数作用是截取的步长，以下实例在索引 1 到索引 4 的位置并设置为步长为 2（间隔一个位置）来截取字符串：

s[1:1:1]  第一个参数从哪开始，从0基数添加，第二个参数是到第几个数，从1开始，第三个参数是步长。从第1个参数跳

```
>>> s = ["a","b","c","d","e","f","g"];s[1:7]
['b', 'c', 'd', 'e', 'f', 'g']
>>> s = ["a","b","c","d","e","f","g"];s[1:7:2]
['b', 'd', 'f']
>>> s = ["a","b","c","d","e","f","g"];s[1:6:2]
['b', 'd', 'f']
>>> s = ["a","b","c","d","e","f","g"];s[1:5]
['b', 'c', 'd', 'e']
>>> s = ["a","b","c","d","e","f","g"];s[1:8]
['b', 'c', 'd', 'e', 'f', 'g']
>>> s = ["a","b","c","d","e","f","g"];s[:]
['a', 'b', 'c', 'd', 'e', 'f', 'g']
>>> s = ["a","b","c","d","e","f","g"];s[::2]
['a', 'c', 'e', 'g']
>>> s = ["a","b","c","d","e","f","g"];s[::3]
['a', 'd', 'g']
>>> s = ["a","b","c","d","e","f","g"];s[:2:3]
['a']
>>> s = ["a","b","c","d","e","f","g"];s[:2:]
['a', 'b']
>>> s = ["a","b","c","d","e","f","g"];s[::5]
['a', 'f']
>>> s = ["a","b","c","d","e","f","g"];s[1:1:]
[]
>>> s = ["a","b","c","d","e","f","g"];s[3:4:]
['d']
>>> s = ["a","b","c","d","e","f","g"];s[3:4:5]
['d']
>>> s = ["a","b","c","d","e","f","g"];s[3:2:]
[]
```





![img](python.assets/python_list_slice_2.png)

字典是无序的对象集合，可以更新赋值，用{}定义

```
#!/usr/bin/python
# -*- coding: UTF-8 -*-

dict = {}
dict['one'] = "This is one"
dict[2] = "This is two"
 
tinydict = {'name': 'runoob','code':6734, 'dept': 'sales'}
 
 
print dict['one']          # 输出键为'one' 的值
print dict[2]              # 输出键为 2 的值
print tinydict             # 输出完整的字典
print tinydict.keys()      # 输出所有键
print tinydict.values()    # 输出所有值
```

```
This is one
This is two
{'dept': 'sales', 'code': 6734, 'name': 'runoob'}
['dept', 'code', 'name']
['sales', 6734, 'runoob']
```

