//
//  LLRefreshHeader.swift
//  LLRefrsh
//
//  Created by LiXingLe on 16/7/25.
//  Copyright © 2016年 com.wildcat. All rights reserved.
//

import UIKit

class LLRefreshHeader: BaseRefreshHeader {
    
    var arrowView:UIImageView?
    let lastUpdateTimeKey = "lastUpdateTimeKey"
    var insetTDelta:CGFloat = 0
    
    /** 忽略多少scrollView的contentInset的top */
    var ignoredScrollViewContentInsetTop:CGFloat = 0

    
    
    override func setState(state:LLRefreshState) {
        let oldValue = refreshState
        super.setState(state)
        guard state != oldValue else {
            return
        }
        
        if state == .Normal{
            if oldValue != LLRefreshState.Refreshing {
                return
            }
            //保存刷新状态
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: lastUpdateTimeKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            // 恢复inset和offset
            
            UIView.animateWithDuration(0.4, animations: {
                self._scrollView?.ll_insetT += self.insetTDelta
                print("self._scrollView?.ll_insetT: \(self._scrollView?.ll_insetT)")
            }, completion: { (finished) in
                self._pullingPercent = 0.0
                if let endRefreshingCompletionBlock = self.endRefreshingCompletionBlock {
                    endRefreshingCompletionBlock()
                }
            })
            
        }else if state == .Refreshing {
            dispatch_async(dispatch_get_main_queue(), {
                UIView.animateWithDuration(0.4, animations: {
                    let top = (self._scrollViewOriginalInset?.top ?? 0) + self.ll_h
                    self._scrollView?.ll_insetT = top
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
    
    override func buildUI() {
        super.buildUI()
        ll_h = LLConstant.HeaderHeight
    }
    
    override func scrollViewContentOffsetDidChange(change: [String : AnyObject]?) {
        super.scrollViewContentOffsetDidChange(change)
        if refreshState == .Refreshing {  //正在刷新
            guard self.window != nil else {
                return
            }
            //停留解决
            var insetT = -(_scrollView?.ll_offsetY ?? 0) > _scrollViewOriginalInset?.top ? -(_scrollView?.ll_offsetY ?? 0) : _scrollViewOriginalInset?.top
            insetT = insetT > self.ll_h + (_scrollViewOriginalInset?.top ?? 0) ? self.ll_h + (_scrollViewOriginalInset?.top ?? 0) : insetT;
            
            print("insetT:::::\(insetT)")
            _scrollView?.ll_insetT = insetT ?? 0
            
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
