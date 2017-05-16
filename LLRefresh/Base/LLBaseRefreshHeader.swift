//
//  BaseRefreshHeader.swift
//  LLRefrsh
//
//  Created by LiXingLe on 16/7/18.
//  Copyright © 2016年 com.wildcat. All rights reserved.
//

import UIKit



public struct LLConstant {
    static let HeaderHeight:CGFloat = 54
    static let FooterHeight:CGFloat = 44.0
    static let AnimationDuration:TimeInterval = 0.4
    static let LastUpdateTimeKey:String = "RefreshHeaderLastUpdatedTimeKey"
    static let RefreshLabelLeftInset:CGFloat = 25
    static let kContentOffset:String = "contentOffset"
    static let kContentSize:String = "contentSize"
    static let kState:String = "state"
    static let kFooterStateTitleNormal = "点击或上拉加载更多"
    static let kFooterStateTitleRefreshing = "正在加载更多的数据..."
    static let kFooterStateTitleNoMoreData = "已经全部加载完毕"
    static let kHeaderStateTitleNormal = "下拉可以刷新"
    static let kHeaderStateTitleRefreshing = "正在刷新数据中"
    static let kHeaderStateTitlePulling = "松开立即刷新"
}


public enum LLRefreshState:Int {
    case normal
    case pulling
    case refreshing
    case willRefresh
    case noMoreData
}

open class LLBaseRefreshHeader: UIView {
    //父控件
    weak var _scrollView:UIScrollView?
    //手势
    var panGesture:UIPanGestureRecognizer?
    ///ScrollView起始位置
    var _scrollViewOriginalInset:UIEdgeInsets?
    ///下拉百分比
    open var _pullingPercent:CGFloat = 0 {
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
    
    open var refreshingBlock:(()->())?
    open var beginRefreshingCompletionBlock:(()->())?
    open var endRefreshingCompletionBlock:(()->())?
    
    open var refreshingTarget:AnyObject?
    open var refreshingAction:Selector?
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepare()
        self.setState(.normal)
    }
    override open func layoutSubviews() {
        placeSubViews()
        super.layoutSubviews()
    }
    override  open func draw(_ rect: CGRect) {
        super.draw(rect)
        if refreshState == .willRefresh {
            setState(.refreshing)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override open func removeFromSuperview() {
        removeLLObservers()
        super.removeFromSuperview()
        
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        
        if let scrollView = newSuperview as? UIScrollView {
            self.removeLLObservers()
            self.ll_w = scrollView.ll_w
            self.ll_x = 0
            
            _scrollView = scrollView
            scrollView.alwaysBounceVertical = true
            _scrollViewOriginalInset = _scrollView?.contentInset
            
            
            scrollView.addObserver(self, forKeyPath: LLConstant.kContentOffset, options: [NSKeyValueObservingOptions.new , NSKeyValueObservingOptions.old], context: nil)
            scrollView.addObserver(self, forKeyPath: LLConstant.kContentSize, options: [NSKeyValueObservingOptions.new , NSKeyValueObservingOptions.old], context: nil)
            
            self.panGesture = _scrollView?.panGestureRecognizer
            self.panGesture?.addObserver(self, forKeyPath: LLConstant.kState, options: [NSKeyValueObservingOptions.new , NSKeyValueObservingOptions.old], context: nil)
            
            
        }
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard isUserInteractionEnabled else {
            return
        }
        if keyPath == LLConstant.kContentSize {
            scrollViewContentSizeDidChange(change as [NSKeyValueChangeKey : Any]?)
        }
        guard !isHidden else {
            return
        }
        if keyPath == LLConstant.kContentOffset {
            scrollViewContentOffsetDidChange(change as [NSKeyValueChangeKey : Any]?)
        }else if keyPath == LLConstant.kState {
            scrollViewPanStateDidChange(change as [NSKeyValueChangeKey : Any]?)
        }
    }
    //MARK: 子类实现
    func scrollViewContentSizeDidChange(_ change:[NSKeyValueChangeKey:Any]?){ }
    func scrollViewContentOffsetDidChange(_ change:[NSKeyValueChangeKey:Any]?){ }
    func scrollViewPanStateDidChange(_ change:[NSKeyValueChangeKey:Any]?){ }
    
    //MARK: - public
    
    open func beginRefreshing()  {
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
    open func endRefreshing()  {
        self.setState(.normal)
    }
    
    open func setRefrshing(target:AnyObject, action:Selector){
        self.refreshingTarget = target
        self.refreshingAction = action
    }
    open func placeSubViews()  {
    }
    
    
    
    open  func prepare(){
        autoresizingMask = .flexibleWidth
        backgroundColor = UIColor.clear
    }
    open  func updateUI()  {
        DispatchQueue.main.async { [weak self] _ in
            self?.setNeedsLayout()
        }
    }
    open func setState(_ state:LLRefreshState) {
        refreshState = state
        updateUI()
    }
    //MARK: - private
    func executeRefreshingCallback() {
        DispatchQueue.main.async(execute: {[weak self] _ in
            if let refreshingBlock = self?.refreshingBlock {
                refreshingBlock()
            }
            if self?.refreshingTarget?.responds(to: self?.refreshingAction) == true{
                if let selector = self?.refreshingAction {
                    (self?.refreshingTarget)?.perform(selector)
                }
            }
            if let beginRefreshingCompletionBlock = self?.beginRefreshingCompletionBlock {
                beginRefreshingCompletionBlock()
            }
        })
    }
    
    func removeLLObservers()  {
        self.superview?.removeObserver(self, forKeyPath: LLConstant.kContentOffset)
        self.superview?.removeObserver(self, forKeyPath: LLConstant.kContentSize)
        self.panGesture?.removeObserver(self, forKeyPath: LLConstant.kState)
        self.panGesture = nil
    }
    
}
