//
//  BaseRefreshHeader.swift
//  LLRefrsh
//
//  Created by LiXingLe on 16/7/18.
//  Copyright © 2016年 com.wildcat. All rights reserved.
//

import UIKit

enum LLRefreshState {
    case Nomal
    case Pulling
    case Refreshing
    case WillRefresh
    case NoMoreData
}

class BaseRefreshHeader: UIView {
    var panGesture:UIPanGestureRecognizer?
    var _refreshState:LLRefreshState = .Nomal
    

    var _scrollView:UIScrollView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildUI()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        placeSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        
        if let scrollView = newSuperview as? UIScrollView {
            self.removeLLObservers()
            
            _scrollView = scrollView
            scrollView.alwaysBounceVertical = true
            self.w = scrollView.w
            
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.Old, context: nil)
            scrollView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
            
            self.panGesture = scrollView.panGestureRecognizer
            self.panGesture?.addObserver(self, forKeyPath: "state", options: NSKeyValueObservingOptions.New, context: nil)
            
            
        }
        
        
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        //        _scrollView!.mj_insetT = 40
        print("Observer Path: \(keyPath)")
    }
    
    
    //MARK: private
    func placeSubViews()  {
    }
    
    func setState(refreshState:LLRefreshState){
        _refreshState = refreshState
        dispatch_async(dispatch_get_main_queue()) { 
            self.setNeedsLayout()
        }
    }
    
    
    func buildUI(){
        self.autoresizingMask = .FlexibleWidth
        self.backgroundColor = UIColor.clearColor()
        self.h = 54
        self.y = -40
        
    }
    
    func removeLLObservers()  {
        self.superview?.removeObserver(self, forKeyPath: "contentOffset")
        self.superview?.removeObserver(self, forKeyPath: "contentSize")
        self.panGesture?.removeObserver(self, forKeyPath: "state")
        self.panGesture = nil
        
    }

}
