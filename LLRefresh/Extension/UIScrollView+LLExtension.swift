//
//  UIScrollView+LLExtension.swift
//  LLRefrsh
//
//  Created by 李兴乐 on 2016/12/2.
//  Copyright © 2016年 com.wildcat. All rights reserved.
//

import UIKit

var LLRefreshHeaderKey = "\0"
var LLRefreshFooterKey = "\0"
var LLRefreshReloadDataBlockKey = "\0"

typealias VoidBlock = (count: Int?)->(Void)

class LLObjectWrapper: NSObject {
    let value: ((count: Int?) -> Void)?
    
    init(value: (count: Int?) -> Void) {
        self.value = value
    }
}

extension UIScrollView {
    var ll_header:LLBaseRefreshHeader? {
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
            let header = objc_getAssociatedObject(self, &LLRefreshHeaderKey) as? LLBaseRefreshHeader
            return header
        }
    }
    
    var ll_footer:LLBaseRefreshHeader? {
        set{
            if newValue != ll_footer {
                self.ll_footer?.removeFromSuperview()
                self.insertSubview(newValue!, atIndex: 0)
                //存储
                self.willChangeValueForKey("ll_footer")
                objc_setAssociatedObject(self, &LLRefreshFooterKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
                self.didChangeValueForKey("ll_footer")
            }
            
        }
        get{
            let header = objc_getAssociatedObject(self, &LLRefreshFooterKey) as? LLBaseRefreshHeader
            return header
        }
    }
    
    var ll_reloadDataBlock:VoidBlock? {
        set{
            self.willChangeValueForKey("ll_reloadDataBlock")
            let wrapper = LLObjectWrapper(value: newValue!)
            objc_setAssociatedObject(self, &LLRefreshReloadDataBlockKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            self.didChangeValueForKey("ll_reloadDataBlock")
        }
        get{
            let wrapper:LLObjectWrapper? = objc_getAssociatedObject(self, &LLRefreshReloadDataBlockKey) as? LLObjectWrapper
            return wrapper?.value
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
    
    
    public var ll_contentH: CGFloat {
        get {
            return self.contentSize.height
        }
        set(value) {
            var contentSize = self.contentSize
            contentSize.height = value
            self.contentSize = contentSize
        }
    }
    
    
}

