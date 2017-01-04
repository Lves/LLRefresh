//
//  LLRefreshAutoFooter.swift
//  LLRefreshDemo
//
//  Created by 李兴乐 on 2016/12/13.
//  Copyright © 2016年 com.lvesli. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class LLRefreshAutoFooter: LLRefreshFooter {
    var triggerAutomaticallyRefreshPercent:CGFloat = 0
    var automaticallyRefresh:Bool = true
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        
        if (newSuperview != nil) {
            if !isHidden {
                let inset = _scrollView?.contentInset ?? UIEdgeInsets.zero
                _scrollView?.contentInset = UIEdgeInsetsMake(inset.top, inset.left, inset.bottom+ll_h, inset.right)
            }
            ll_y = _scrollView?.ll_contentH ?? 0
        }else {
            if !isHidden {
                let inset = _scrollView?.contentInset ?? UIEdgeInsets.zero
                _scrollView?.contentInset = UIEdgeInsetsMake(inset.top, inset.left, inset.bottom-ll_h, inset.right)
            }
        }

    }
    
    override func prepare() {
        super.prepare()
        triggerAutomaticallyRefreshPercent = 1.0
        
    }
    override func scrollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChange(change)
        ll_y = _scrollView?.ll_contentH ?? 0 //改变位置
    }
    override func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change)
        
        if refreshState != .normal || automaticallyRefresh == false || ll_y == 0 {
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
                let old = change?[NSKeyValueChangeKey.oldKey] as? CGPoint
                let new = change?[NSKeyValueChangeKey.newKey] as? CGPoint
////              let old = change?["old"]?.cgPointValue
//                let new = change?["new"]?.cgPointValue
                if new?.y <= old?.y {
                    return
                }
                
                // 当底部刷新控件完全出现时，才刷新
                beginRefreshing()
            }
        }
        
    }
    override func scrollViewPanStateDidChange(_ change: [NSKeyValueChangeKey:Any]?) {
        super.scrollViewPanStateDidChange(change)
        
        if refreshState != .normal {
            return
        }
        guard let scrollView = _scrollView else {
            return
        }
        
        if scrollView.panGestureRecognizer.state == .ended { //手松开
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
    
    override func setState(_ state: LLRefreshState) {
        let oldValue = refreshState
        guard state != oldValue else {
            return
        }
        super.setState(state)
        
        if state == .refreshing {
            let t = DispatchTime.now() + Double(Int64(0.5*Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: t, execute: { 
                self.executeRefreshingCallback()
            })
            
        }else if state == .noMoreData || state == .normal {
            if oldValue == .refreshing {
                if let endRefreshingCompletionBlock = endRefreshingCompletionBlock {
                    endRefreshingCompletionBlock()
                }
            }
        }
    }
    
    override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set(v) {
            let oldValue = super.isHidden
            super.isHidden = v
            
            if oldValue == false && v {
                setState(.normal)
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
