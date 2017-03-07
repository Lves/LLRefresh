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
    static let FooterHeight:CGFloat = 44.0
    static let AnimationDuration:TimeInterval = 0.4
    static let LastUpdateTimeKey:String = "RefreshHeaderLastUpdatedTimeKey"
    static let RefreshLabelLeftInset:CGFloat = 25
}


enum LLRefreshState:Int {
    case normal
    case pulling
    case refreshing
    case willRefresh
    case noMoreData
}

class LLBaseRefreshHeader: UIView {
    //父控件
    weak var _scrollView:UIScrollView?
    //手势
    var panGesture:UIPanGestureRecognizer?
    ///ScrollView起始位置
    var _scrollViewOriginalInset:UIEdgeInsets?
    ///下拉百分比
    var _pullingPercent:CGFloat = 0 {
        didSet{
            guard !isRefreshing else {
                return
            }
            //修改透明度
        }
    }
    
    
    var isRefreshing:Bool{
        return refreshState == .refreshing || refreshState == .willRefresh
    }
    //状态
    var refreshState:LLRefreshState = .normal
    
    var refreshingBlock:(()->())?
    var beginRefreshingCompletionBlock:(()->())?
    var endRefreshingCompletionBlock:(()->())?
    
    var refreshingTarget:AnyObject?
    var refreshingAction:Selector?
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepare()
        self.setState(.normal)
    }
    override func layoutSubviews() {
        placeSubViews()
        super.layoutSubviews()
        
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if refreshState == .willRefresh {
            setState(.refreshing)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func removeFromSuperview() {
        removeLLObservers()
        super.removeFromSuperview()
        
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        
        if let scrollView = newSuperview as? UIScrollView {
            self.removeLLObservers()
            self.ll_w = scrollView.ll_w
            self.ll_x = 0
            
            _scrollView = scrollView
            scrollView.alwaysBounceVertical = true
            _scrollViewOriginalInset = _scrollView?.contentInset
            
            
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: [NSKeyValueObservingOptions.new , NSKeyValueObservingOptions.old], context: nil)
            scrollView.addObserver(self, forKeyPath: "contentSize", options: [NSKeyValueObservingOptions.new , NSKeyValueObservingOptions.old], context: nil)
            
            self.panGesture = _scrollView?.panGestureRecognizer
            self.panGesture?.addObserver(self, forKeyPath: "state", options: [NSKeyValueObservingOptions.new , NSKeyValueObservingOptions.old], context: nil)
            
            
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard isUserInteractionEnabled else {
            return
        }
        if keyPath == "contentSize" {
            scrollViewContentSizeDidChange(change as [NSKeyValueChangeKey : Any]?)
        }
        guard !isHidden else {
            return
        }
        if keyPath == "contentOffset" {
            scrollViewContentOffsetDidChange(change as [NSKeyValueChangeKey : Any]?)
        }else if keyPath == "state" {
            scrollViewPanStateDidChange(change as [NSKeyValueChangeKey : Any]?)
        }
    }
    //MARK: 子类实现
    func scrollViewContentSizeDidChange(_ change:[NSKeyValueChangeKey:Any]?){ }
    func scrollViewContentOffsetDidChange(_ change:[NSKeyValueChangeKey:Any]?){ }
    func scrollViewPanStateDidChange(_ change:[NSKeyValueChangeKey:Any]?){ }
    
    //MARK: - public
    
    func beginRefreshing()  {
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 1.0
        })
        _pullingPercent = 1.0
        if (self.window != nil) {
            self.setState(.refreshing)
        }else {
            if refreshState != .refreshing {
                self.setState(.willRefresh)
                setNeedsDisplay()
            }
        }
    }
    func endRefreshing()  {
        self.setState(.normal)
    }
    
    func setRefrshing(target:AnyObject, action:Selector){
        self.refreshingTarget = target
        self.refreshingAction = action
    }
    
    //MARK: - private
    func placeSubViews()  {
    }
    
    func executeRefreshingCallback() {
        DispatchQueue.main.async(execute: {[weak self] _ in
            if let refreshingBlock = self?.refreshingBlock {
                refreshingBlock()
            }

            
            if self?.refreshingTarget?.responds(to: self?.refreshingAction) == true{
                self?.refreshingTarget?.perform(self?.refreshingAction)
               
            }
            if let beginRefreshingCompletionBlock = self?.beginRefreshingCompletionBlock {
                beginRefreshingCompletionBlock()
            }
        })
    }
    
    
    func prepare(){
        autoresizingMask = .flexibleWidth
        backgroundColor = UIColor.clear
    }
    func updateUI()  {
        DispatchQueue.main.async { [weak self] _ in
            self?.setNeedsLayout()
        }
    }
    func setState(_ state:LLRefreshState) {
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
