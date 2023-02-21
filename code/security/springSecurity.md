# springSecurity

## 代码地址

[gitea]()


## study


> DelegatingFilterProxy
> 
Spring提供了一个名为DelegatingFilterProxy的Filter实现，它允许Servlet容器的生命周期和Spring的ApplicationContext之间的桥接。Servlet容器允许使用它自己的标准来注册Filter实例，但是它不知道spring定义的bean。您可以通过标准的Servlet容器机制注册DelegatingFilterProxy，但将所有工作委托给实现Filter的Spring Bean。

DelegatingFilterProxy从ApplicationContext中查找Bean Filter0，然后调用Bean Filter0。


DelegatingFilterProxy的另一个好处是它允许延迟查找Filter bean实例。这很重要，因为容器需要在容器启动之前注册Filter实例。然而，Spring通常使用ContextLoaderListener来加载Spring bean，这在需要注册Filter实例之后才会完成。


## FilterChainProxy
Spring Security的Servlet支持包含在FilterChainProxy中。
FilterChainProxy是Spring Security提供的一个特殊的过滤器，它允许通过SecurityFilterChain委托给许多过滤器实例。
因为FilterChainProxy是一个Bean，所以它通常被包装在一个DelegatingFilterProxy中。

## SecurityFilterChain
FilterChainProxy 使用 SecurityFilterChain 来确定当前请求应该调用哪些Spring安全过滤器实例。



>
>>
# 123
## 324
```
dfsgsdfsd
```