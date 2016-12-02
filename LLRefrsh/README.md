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
let refrshHeader = LLRefreshStateHeader()
refrshHeader.refreshingBlock = {[weak self] _ in
     sleep(2)
     self?.tableView.ll_header?.endRefreshing()
}
self.tableView.ll_header = refrshHeader
self.tableView.ll_header?.beginRefreshing()
```





### Doing




