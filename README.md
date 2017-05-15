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
- Swift 3.0+

### Installation

#### 1. CocoaPods

```
pod 'LXLRefresh'
```

#### 2. SourceCode



### Usage
引入Module
```swift
import LLRefresh
```

使用时可以使用target或者block

- Block
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
- Target
```swift
tableView.ll_header = LLRefreshStateHeader(target: self, action: #selector(loadNewData))
tableView.ll_header?.beginRefreshing()
 func loadNewData()  {
    //update data
    sleep(2)
    //end refreshing
    tableView.ll_header?.endRefreshing()
    tableView.reloadData()
  }
```

具体使用和自定义可以下载demo查看

### Demo


1. Noraml refresh header

![normal](https://github.com/Lves/LLRefresh/blob/master/Docs/123.png)

2. Refresh header with BgImage

![bgheader](https://github.com/Lves/LLRefresh/blob/master/Docs/234.png)

3. Refresh header with Gif

![bgheader](https://github.com/Lves/LLRefresh/blob/master/Docs/QQLLRefresh_gif.gif)

4. Refresh footer

<iframe height=498 width=510 src="https://github.com/Lves/LLRefresh/blob/master/Docs/footer_movie.mp4">

