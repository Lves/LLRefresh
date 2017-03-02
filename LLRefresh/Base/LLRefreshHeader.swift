//
//  LLRefreshHeader.swift
//  LLRefrsh
//
//  Created by LiXingLe on 16/7/25.
//  Copyright © 2016年 com.wildcat. All rights reserved.
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
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class LLRefreshHeader: LLBaseRefreshHeader {
    
    
    ///last update time
    var lastUpdateTime:Date? {
        get{
            return UserDefaults.standard.object(forKey: LLConstant.LastUpdateTimeKey) as? Date
        }
    }
    var insetTDelta:CGFloat = 0
    
    init() {
        super.init(frame: CGRect.zero)
    }
    init(refreshingBlock:(()->())?) {
        super.init(frame: CGRect.zero)
        self.refreshingBlock = refreshingBlock
    }
    init(target:AnyObject , action: Selector){
        super.init(frame: CGRect.zero)
        self.setRefrshing(target: target, action: action)
        
    }
    class func header(target:AnyObject , action: Selector) -> LLRefreshHeader{
        let header = LLRefreshHeader()
        header.setRefrshing(target: target, action: action)
        return header
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
    /** 忽略多少scrollView的contentInset的top */
    var ignoredScrollViewContentInsetTop:CGFloat = 0

    override func setState(_ state:LLRefreshState) {
        let oldValue = refreshState
        guard state != oldValue else {
            return
        }
        super.setState(state)
        if state == .normal{
            if oldValue != LLRefreshState.refreshing {
                return
            }
            //保存刷新时间
            UserDefaults.standard.set(Date(), forKey: LLConstant.LastUpdateTimeKey)
            UserDefaults.standard.synchronize()
            // 恢复inset和offset
            UIView.animate(withDuration: LLConstant.AnimationDuration, animations: {
                let top = (self._scrollView?.contentInset.top ?? 0) + self.insetTDelta
                self._scrollView?.contentInset = UIEdgeInsetsMake(top, 0, 0, 0)
            }, completion: { (finished) in
                self._pullingPercent = 0.0
                if let endRefreshingCompletionBlock = self.endRefreshingCompletionBlock {
                    endRefreshingCompletionBlock()
                }
            })
            
        }else if state == .refreshing {
            DispatchQueue.main.async(execute: {
                UIView.animate(withDuration: LLConstant.AnimationDuration, animations: {
                    let top = (self._scrollViewOriginalInset?.top ?? 0) + self.ll_h
                    self._scrollView?.contentInset = UIEdgeInsetsMake(top, 0, 0, 0)
                    self._scrollView?.setContentOffset(CGPoint(x: 0, y: -top), animated: false)
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
    
    override func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey:Any]?) {
        super.scrollViewContentOffsetDidChange(change)
        if refreshState == .refreshing {  //正在刷新
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

        if (self._scrollView?.isDragging == true) { // 如果正在拖拽
            self._pullingPercent = pullingPercent;
            if (self.refreshState == .normal && offsetY < normal2pullingOffsetY) {
                // 转为即将刷新状态
                self.setState(.pulling)
            } else if (self.refreshState == .pulling && offsetY >= normal2pullingOffsetY) {
                // 转为普通状态
                self.setState(.normal)
            }
        } else if (self.refreshState == .pulling) {// 即将刷新 && 手松开
            // 开始刷新
            beginRefreshing()
        } else if (pullingPercent < 1) {
            _pullingPercent = pullingPercent
        }
    }

    //MARK: - public
    override func endRefreshing()  {
        DispatchQueue.main.async(execute: {
            self.setState(.normal)
        })
    }
    
  
}
