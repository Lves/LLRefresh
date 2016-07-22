//
//  UIScrollViewExtension.swift
//  LLRefrsh
//
//  Created by LiXingLe on 16/7/22.
//  Copyright © 2016年 com.wildcat. All rights reserved.
//

import Foundation
import UIKit


var LLRefreshHeaderKey = "\0"

extension UIScrollView {
    
    
    
    var ll_header:BaseRefreshHeader? {
        set{
            if newValue != ll_header {
                self.ll_header?.removeFromSuperview()
                self.insertSubview(newValue!, atIndex: 0)
                //存储
                self.willChangeValueForKey("ll_header")
                objc_setAssociatedObject(self, &LLRefreshHeaderKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
                self.didChangeValueForKey("ll_header")
            }
            
        }
        get{
            
            let header = objc_getAssociatedObject(self, &LLRefreshHeaderKey) as? BaseRefreshHeader
            
            return header
        }
    }

}






extension UIView {
    /// EZSwiftExtensions
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        } set(value) {
            self.frame = CGRect(x: value, y: self.y, width: self.w, height: self.h)
        }
    }
    
    /// EZSwiftExtensions
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        } set(value) {
            self.frame = CGRect(x: self.x, y: value, width: self.w, height: self.h)
        }
    }
    
    /// EZSwiftExtensions
    public var w: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: value, height: self.h)
        }
    }
    
    /// EZSwiftExtensions
    public var h: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: self.w, height: value)
        }
    }

}








