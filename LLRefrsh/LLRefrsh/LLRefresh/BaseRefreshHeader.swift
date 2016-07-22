//
//  BaseRefreshHeader.swift
//  LLRefrsh
//
//  Created by LiXingLe on 16/7/18.
//  Copyright © 2016年 com.wildcat. All rights reserved.
//

import UIKit

class BaseRefreshHeader: UIView {

    var _scrollView:UIScrollView?
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        
        if let scrollView = newSuperview as? UIScrollView {
            _scrollView = scrollView
            scrollView.alwaysBounceVertical = true
            
            
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.Old, context: nil)
            
            
        }
        
        
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        //        _scrollView!.mj_insetT = 40
    }

}
