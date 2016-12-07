//
//  LLRefreshHeader.swift
//  LLRefrsh
//
//  Created by LiXingLe on 16/7/25.
//  Copyright © 2016年 com.wildcat. All rights reserved.
//

import UIKit

class LLRefreshHeader: LLBaseRefreshHeader {
    
    
    ///last update time
    var lastUpdateTime:NSDate? {
        get{
            return NSUserDefaults.standardUserDefaults().objectForKey(LLConstant.LastUpdateTimeKey) as? NSDate
        }
    }
    var insetTDelta:CGFloat = 0
    
    init() {
        super.init(frame: CGRectZero)
    }
    init(refreshingBlock:(()->())?) {
        super.init(frame: CGRectZero)
        self.refreshingBlock = refreshingBlock
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
    /** 忽略多少scrollView的contentInset的top */
    var ignoredScrollViewContentInsetTop:CGFloat = 0

    override func setState(state:LLRefreshState) {
        let oldValue = refreshState
        guard state != oldValue else {
            return
        }
        super.setState(state)
        if state == .Normal{
            if oldValue != LLRefreshState.Refreshing {
                return
            }
            //保存刷新时间
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: LLConstant.LastUpdateTimeKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            // 恢复inset和offset
            UIView.animateWithDuration(LLConstant.AnimationDuration, animations: {
                let top = (self._scrollView?.contentInset.top ?? 0) + self.insetTDelta
                self._scrollView?.contentInset = UIEdgeInsetsMake(top, 0, 0, 0)
            }, completion: { (finished) in
                self._pullingPercent = 0.0
                if let endRefreshingCompletionBlock = self.endRefreshingCompletionBlock {
                    endRefreshingCompletionBlock()
                }
            })
            
        }else if state == .Refreshing {
            dispatch_async(dispatch_get_main_queue(), {
                UIView.animateWithDuration(LLConstant.AnimationDuration, animations: {
                    let top = (self._scrollViewOriginalInset?.top ?? 0) + self.ll_h
                    self._scrollView?.contentInset = UIEdgeInsetsMake(top, 0, 0, 0)
                    self._scrollView?.setContentOffset(CGPointMake(0, -top), animated: false)
                }, completion: { (finished) in
                    self.executeRefreshingCallback()
                })
            })
        }
       
    }
    
    override func placeSubViews() {
        super.placeSubViews()
        self.ll_y = -ll_h - ignoredScrollViewContentInsetTop
    }
    
    override func prepare() {
        super.prepare()
        ll_h = LLConstant.HeaderHeight
    }
    
    override func scrollViewContentOffsetDidChange(change: [String : AnyObject]?) {
        super.scrollViewContentOffsetDidChange(change)
        if refreshState == .Refreshing {  //正在刷新
            guard self.window != nil else {
                return
            }
            //停留解决
            //1.1 有下拉距离则使用下拉距离
            var insetT = -(_scrollView?.ll_offsetY ?? 0) > _scrollViewOriginalInset?.top ? -(_scrollView?.ll_offsetY ?? 0) : _scrollViewOriginalInset?.top
            //1.2 下拉距离和content顶部距离使用小的那个
            let contentTopH:CGFloat = self.ll_h + (_scrollViewOriginalInset?.top ?? 0)
            insetT = insetT > contentTopH ? contentTopH : insetT;
            
//            _scrollView?.ll_insetT = insetT ?? 0
            self._scrollView?.contentInset = UIEdgeInsetsMake(insetT ?? 0, 0, 0, 0)
            
            self.insetTDelta = (_scrollViewOriginalInset?.top ?? 0) - (insetT ?? 0)
            return
        }
        _scrollViewOriginalInset = _scrollView?.contentInset
        let offsetY = _scrollView?.ll_offsetY
        let happenOffsetY = -(_scrollViewOriginalInset?.top ?? 0)
        if offsetY > happenOffsetY {
            return
        }
        
        // 普通 和 即将刷新 的临界点
        let normal2pullingOffsetY = happenOffsetY - self.ll_h;
        let pullingPercent = (happenOffsetY - (offsetY ?? 0)) / self.ll_h;

        if (self._scrollView?.dragging == true) { // 如果正在拖拽
            self._pullingPercent = pullingPercent;
            if (self.refreshState == .Normal && offsetY < normal2pullingOffsetY) {
                // 转为即将刷新状态
                self.setState(.Pulling)
            } else if (self.refreshState == .Pulling && offsetY >= normal2pullingOffsetY) {
                // 转为普通状态
                self.setState(.Normal)
            }
        } else if (self.refreshState == .Pulling) {// 即将刷新 && 手松开
            // 开始刷新
            beginRefreshing()
        } else if (pullingPercent < 1) {
            _pullingPercent = pullingPercent
        }
    }

    //MARK: - public
    override func endRefreshing()  {
        dispatch_async(dispatch_get_main_queue(), {
            self.setState(.Normal)
        })
    }
    
  
}
