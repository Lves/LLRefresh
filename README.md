# LLRefresh

* 用Swift实现下拉刷新，上滑加载更多（LLRefresh is a pull&push to refresh library written in Swift）



### Features

- 下拉刷新(pull to refresh )
- 上滑加载更多(push to load more)
- 动画(Animation)
- 自定义(Custom)

### Requirements

- iOS 8.0+ 
- Xcode 8.0+
- Swift 2.3+

### Installation

#### 1. CocoaPods



#### 2. SourceCode



### Usage



```swift
//1.0 Init
self.tableView.ll_header =  LLRefreshStateHeader {[weak self] _ in
    sleep(2)
    //3.0 Stop Refreshing
    self?.tableView.ll_header?.endRefreshing()
}
//2.0 Begin refreshing
self.tableView.ll_header?.beginRefreshing()
```





### Demo

1. Noraml refresh header

![normal](https://github.com/Lves/LLRefresh/blob/master/Docs/123.png)

2. Refresh header with BgImage

![bgheader](https://github.com/Lves/LLRefresh/blob/master/Docs/234.png)

3. Refresh header with Gif

![bgheader](https://github.com/Lves/LLRefresh/blob/master/Docs/QQLLRefresh_gif.gif)



