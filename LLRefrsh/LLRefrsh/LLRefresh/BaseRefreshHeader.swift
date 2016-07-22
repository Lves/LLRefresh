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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        
        if let scrollView = newSuperview as? UIScrollView {
            _scrollView = scrollView
            scrollView.alwaysBounceVertical = true
            self.w = scrollView.w
            
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.Old, context: nil)
            
            
        }
        
        
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        //        _scrollView!.mj_insetT = 40
    }
    
    
    //MARK: private
    func buildUI(){
        self.autoresizingMask = .FlexibleWidth
        self.backgroundColor = UIColor.clearColor()
        self.h = 54
        self.y = -40
        
    }

}
