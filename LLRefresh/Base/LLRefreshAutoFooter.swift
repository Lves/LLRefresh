//
//  LLRefreshAutoFooter.swift
//  LLRefreshDemo
//
//  Created by 李兴乐 on 2016/12/13.
//  Copyright © 2016年 com.lvesli. All rights reserved.
//

import UIKit

class LLRefreshAutoFooter: LLRefreshFooter {
    var triggerAutomaticallyRefreshPercent:CGFloat = 0
    var automaticallyRefresh:Bool = true
    
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        
        if (newSuperview != nil) {
            if !hidden {
                let inset = _scrollView?.contentInset ?? UIEdgeInsetsZero
                _scrollView?.contentInset = UIEdgeInsetsMake(inset.top, inset.left, inset.bottom+ll_h, inset.right)
            }
            ll_y = _scrollView?.ll_contentH ?? 0
        }else {
            if !hidden {
                let inset = _scrollView?.contentInset ?? UIEdgeInsetsZero
                _scrollView?.contentInset = UIEdgeInsetsMake(inset.top, inset.left, inset.bottom-ll_h, inset.right)
            }
        }

    }
    
    override func prepare() {
        super.prepare()
        triggerAutomaticallyRefreshPercent = 1.0
        
    }
    override func scrollViewContentSizeDidChange(change: [String : AnyObject]?) {
        super.scrollViewContentSizeDidChange(change)
        ll_y = _scrollView?.ll_contentH ?? 0 //改变位置
    }
    override func scrollViewContentOffsetDidChange(change: [String : AnyObject]?) {
        super.scrollViewContentOffsetDidChange(change)
        
        if refreshState != .Normal || automaticallyRefresh == false || ll_y == 0 {
            return
        }
        
        guard let scrollView = _scrollView else {
            return
        }
        
        //内容超过一个屏幕
        if scrollView.contentInset.top + scrollView.ll_contentH > scrollView.ll_h{
            // 这里的_scrollView.mj_contentH替换掉self.mj_y更为合理
            if (scrollView.ll_offsetY >= scrollView.ll_contentH - scrollView.ll_h + self.ll_h * self.triggerAutomaticallyRefreshPercent + scrollView.contentInset.bottom - self.ll_h) {
                // 防止手松开时连续调用
                let old = change?["old"]?.CGPointValue()
                let new = change?["new"]?.CGPointValue()
                if new?.y <= old?.y {
                    return
                }
                
                // 当底部刷新控件完全出现时，才刷新
                beginRefreshing()
            }
        }
        
    }
    override func scrollViewPanStateDidChange(change: [String : AnyObject]?) {
        super.scrollViewPanStateDidChange(change)
        
        if refreshState != .Normal {
            return
        }
        guard let scrollView = _scrollView else {
            return
        }
        
        if scrollView.panGestureRecognizer.state == .Ended { //手松开
            if (scrollView.contentInset.top + scrollView.ll_contentH <= scrollView.ll_h) {  // 不够一个屏幕
                if (scrollView.contentOffset.y >= -scrollView.contentInset.top) { // 向上拽
                    beginRefreshing()
                }
            } else { // 超出一个屏幕
                if (scrollView.ll_offsetY >= scrollView.ll_contentH + scrollView.contentInset.bottom - scrollView.ll_h) {
                    beginRefreshing()
                }
            }
        }
        
    }
    
    override func setState(state: LLRefreshState) {
        let oldValue = refreshState
        guard state != oldValue else {
            return
        }
        super.setState(state)
        
        if state == .Refreshing {
            let t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5*Double(NSEC_PER_SEC)))
            dispatch_after(t, dispatch_get_main_queue(), { 
                self.executeRefreshingCallback()
            })
            
        }else if state == .NoMoreData || state == .Normal {
            if oldValue == .Refreshing {
                if let endRefreshingCompletionBlock = endRefreshingCompletionBlock {
                    endRefreshingCompletionBlock()
                }
            }
        }
    }
    
    override var hidden: Bool {
        get {
            return super.hidden
        }
        set(v) {
            let oldValue = super.hidden
            super.hidden = v
            
            if oldValue == false && v {
                setState(.Normal)
                var content = _scrollView?.contentInset
                content?.bottom -= ll_h
                _scrollView?.contentInset = content!
            }else if oldValue && v == false {
                var content = _scrollView?.contentInset
                content?.bottom += ll_h
                _scrollView?.contentInset = content!
                
                // 设置位置
                ll_y = (_scrollView?.ll_contentH ?? 0)
            }
            
            
        }
    }
   

}
