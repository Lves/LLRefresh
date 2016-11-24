//
//  UIScrollView+Extension.swift
//  LLRefrsh
//
//  Created by LiXingLe on 16/11/24.
//  Copyright © 2016年 com.wildcat. All rights reserved.
//

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


extension UIScrollView {
    public var ll_offsetY: CGFloat {
        get {
            return self.contentOffset.y
        } set(value) {
            var offset = self.contentOffset
            offset.y = ll_offsetY
            self.contentOffset = offset
        }
    }
    public var ll_insetT:CGFloat {
        get {
            return self.contentInset.top
        } set(value) {
            var contentInset = self.contentInset
            contentInset.top = ll_insetT
            self.contentInset = contentInset
        }
    }

    
}
