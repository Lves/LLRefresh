//
//  BaseRefreshHeader.swift
//  LLRefrsh
//
//  Created by LiXingLe on 16/7/18.
//  Copyright © 2016年 com.wildcat. All rights reserved.
//

import UIKit



struct LLConstant {
    static let HeaderHeight:CGFloat = 54
    static let AnimationDuration:NSTimeInterval = 0.4
    static let LastUpdateTimeKey:String = "RefreshHeaderLastUpdatedTimeKey"
}


enum LLRefreshState:Int {
    case Normal
    case Pulling
    case Refreshing
    case WillRefresh
    case NoMoreData
}

class LLBaseRefreshHeader: UIView {
    var panGesture:UIPanGestureRecognizer?
    
    var refreshState:LLRefreshState = .Normal
    ///下拉百分比
    var _pullingPercent:CGFloat = 0
    ///ScrollView起始位置
    var _scrollViewOriginalInset:UIEdgeInsets?
    
    
    //父控件
    weak var _scrollView:UIScrollView?
    
    
    var refreshingBlock:(()->())?
    var beginRefreshingCompletionBlock:(()->())?
    var endRefreshingCompletionBlock:(()->())?
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepare()
        self.setState(.Normal)
    }
    override func layoutSubviews() {
        placeSubViews()
        super.layoutSubviews()
        
    }
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if refreshState == .WillRefresh {
            setState(.Refreshing)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        
        if let scrollView = newSuperview as? UIScrollView {
            self.removeLLObservers()
            self.ll_w = scrollView.ll_w
            self.ll_x = 0
            
            _scrollView = scrollView
            scrollView.alwaysBounceVertical = true
            _scrollViewOriginalInset = _scrollView?.contentInset
            
            
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: [NSKeyValueObservingOptions.New , NSKeyValueObservingOptions.Old], context: nil)
            scrollView.addObserver(self, forKeyPath: "contentSize", options: [NSKeyValueObservingOptions.New , NSKeyValueObservingOptions.Old], context: nil)
            
            self.panGesture = scrollView.panGestureRecognizer
            self.panGesture?.addObserver(self, forKeyPath: "state", options: [NSKeyValueObservingOptions.New , NSKeyValueObservingOptions.Old], context: nil)
            
            
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        guard userInteractionEnabled else {
            return
        }
        if keyPath == "contentSize" {
            scrollViewContentSizeDidChange(change)
        }
        guard !hidden else {
            return
        }
        if keyPath == "contentOffset" {
            scrollViewContentOffsetDidChange(change)
        }else if keyPath == "state" {
            scrollViewPanStateDidChange(change)
        }
    }
    //MARK: 子类实现
    func scrollViewContentSizeDidChange(change:[String:AnyObject]?){ }
    func scrollViewContentOffsetDidChange(change:[String:AnyObject]?){ }
    func scrollViewPanStateDidChange(change:[String:AnyObject]?){ }
    
    //MARK: - public
    
    func beginRefreshing()  {
        UIView.animateWithDuration(0.4, animations: {
            self.alpha = 1.0
        })
        _pullingPercent = 1.0
        if (self.window != nil) {
            self.setState(.Refreshing)
        }else {
            if refreshState != .Refreshing {
                self.setState(.Refreshing)
                setNeedsDisplay()
            }
        }
        
    }
    func endRefreshing()  {
        self.setState(.Normal)
    }
    
    //MARK: - private
    func placeSubViews()  {
    }
    
    func executeRefreshingCallback() {
        dispatch_async(dispatch_get_main_queue(), {[weak self] _ in
            if let refreshingBlock = self?.refreshingBlock {
                refreshingBlock()
            }
            if let beginRefreshingCompletionBlock = self?.beginRefreshingCompletionBlock {
                beginRefreshingCompletionBlock()
            }
            })
    }
    
    
    func prepare(){
        autoresizingMask = .FlexibleWidth
        backgroundColor = UIColor.clearColor()
    }
    func updateUI()  {
        dispatch_async(dispatch_get_main_queue()) { [weak self] _ in
            self?.setNeedsLayout()
        }
    }
    func setState(state:LLRefreshState) {
        refreshState = state
        print("state -> \(state)")
        updateUI()
    }
    
    func removeLLObservers()  {
        self.superview?.removeObserver(self, forKeyPath: "contentOffset")
        self.superview?.removeObserver(self, forKeyPath: "contentSize")
        self.panGesture?.removeObserver(self, forKeyPath: "state")
        self.panGesture = nil
    }
    
}
