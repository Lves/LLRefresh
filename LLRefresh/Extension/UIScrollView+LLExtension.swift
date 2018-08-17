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

public typealias VoidBlock = (_ count: Int?)->(Void)

class LLObjectWrapper: NSObject {
    let value: ((_ count: Int?) -> Void)?
    
    init(value: @escaping (_ count: Int?) -> Void) {
        self.value = value
    }
}

public extension UIScrollView {
    public var ll_header:LLBaseRefreshHeader? {
        set{
            if newValue != ll_header {
                self.ll_header?.removeFromSuperview()
                self.insertSubview(newValue!, at: 0)
                //存储
                self.willChangeValue(forKey: "ll_header")
                objc_setAssociatedObject(self, &LLRefreshHeaderKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
                self.didChangeValue(forKey: "ll_header")
            }
            
        }
        get{
            let header = objc_getAssociatedObject(self, &LLRefreshHeaderKey) as? LLBaseRefreshHeader
            return header
        }
    }
    
    public var ll_footer:LLBaseRefreshHeader? {
        set{
            if newValue != ll_footer {
                self.ll_footer?.removeFromSuperview()
                self.insertSubview(newValue!, at: 0)
                //存储
                self.willChangeValue(forKey: "ll_footer")
                objc_setAssociatedObject(self, &LLRefreshFooterKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
                self.didChangeValue(forKey: "ll_footer")
            }
            
        }
        get{
            let header = objc_getAssociatedObject(self, &LLRefreshFooterKey) as? LLBaseRefreshHeader
            return header
        }
    }
    
   public  var ll_reloadDataBlock:VoidBlock? {
        set{
            self.willChangeValue(forKey: "ll_reloadDataBlock")
            let wrapper = LLObjectWrapper(value: newValue!)
            objc_setAssociatedObject(self, &LLRefreshReloadDataBlockKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            self.didChangeValue(forKey: "ll_reloadDataBlock")
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
    public var ll_insetTop: CGFloat {
        get {
            return self.contentInset.top
        }
        set(value) {
            var contentInset = self.contentInset
            contentInset.top = value
            self.contentInset = contentInset
        }
    }
    public var ll_insetBottom: CGFloat {
        get {
            return self.contentInset.bottom
        }
        set(value) {
            var contentInset = self.contentInset
            contentInset.bottom = value
            self.contentInset = contentInset
        }
    }
    public var ll_insetLeft: CGFloat {
        get {
            return self.contentInset.left
        }
        set(value) {
            var contentInset = self.contentInset
            contentInset.left = value
            self.contentInset = contentInset
        }
    }
    public var ll_insetRight: CGFloat {
        get {
            return self.contentInset.right
        }
        set(value) {
            var contentInset = self.contentInset
            contentInset.right = value
            self.contentInset = contentInset
        }
    }
    
    
    
}

